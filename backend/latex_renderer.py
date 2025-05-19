import os
import re
import subprocess
import uuid
import base64

#Direction of code
OUTPUT_DIR = "outputs"
LOG_DIR = os.path.join(OUTPUT_DIR, "logs") #To debug
AUX_DIR = os.path.join(OUTPUT_DIR, "aux") #To save metadata
TEX_DIR = os.path.join(OUTPUT_DIR, "tex") #To save latex code
PDF_DIR = os.path.join(OUTPUT_DIR, "pdf") #To save pdf file

#Create folder to save file
for folder in [OUTPUT_DIR, LOG_DIR, AUX_DIR, TEX_DIR, PDF_DIR]:
    if not os.path.exists(folder):
        os.makedirs(folder)

def convert_image_to_base64(image_path: str) -> str:
    with open(image_path, "rb") as img_file:
        return base64.b64encode(img_file.read()).decode('utf-8')

def render_latex_to_image(latex_code: str) -> str:
    unique_id = uuid.uuid4().hex

    #file path
    tex_path = os.path.join(TEX_DIR, f"{unique_id}.tex")
    pdf_path = os.path.join(PDF_DIR, f"{unique_id}.pdf")
    png_path = os.path.join(OUTPUT_DIR, f"{unique_id}.png")
    aux_path = os.path.join(AUX_DIR, f"{unique_id}.aux")
    log_path = os.path.join(LOG_DIR, f"{unique_id}.log")

    # Detect if it is full LaTeX document (e.g., TikZ with \documentclass)
    is_full_document = re.search(r"\\documentclass\{.*?\}", latex_code.strip()) is not None

    #Create content of Latex File
    if is_full_document:
        full_latex = latex_code.strip()
        print("Detected full LaTeX document.")
    else:
        full_latex = rf"""
        \documentclass[preview]{{standalone}}
        \usepackage{{tikz}}
        \usepackage{{amsmath, amssymb, xcolor, mhchem}} % support many type of LaTeX commands
        \begin{{document}}
        {latex_code}
        \end{{document}}
        """

    #Write file
    with open(tex_path, "w") as f:
        f.write(full_latex.strip())  # Avoid newline if not nessesary

    #Compile .tex to .pdf
    try:
        subprocess.run(["pdflatex", "-interaction=nonstopmode", "-output-directory", PDF_DIR, tex_path],
                       check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError as e:
        print("❌ LaTeX compile error:", e)
        return None

    #Move .aux and .log to its folder
    generated_aux = os.path.join(PDF_DIR, f"{unique_id}.aux")
    generated_log = os.path.join(PDF_DIR, f"{unique_id}.log")
    if os.path.exists(generated_aux):
        os.rename(generated_aux, aux_path)
    if os.path.exists(generated_log):
        os.rename(generated_log, log_path)

    #Conver .pdf to .png (ImageMagick)
    try:
        subprocess.run(["convert", "-density", "300", pdf_path, "-quality", "90", png_path],
                       check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError as e:
        print("❌ ImageMagick error:", e)
        return None

    if os.path.exists(png_path):
        return convert_image_to_base64(png_path)
    else:
        print("❌ PNG not created:", png_path)
        return None

#Render all latex blocks in a list
def render_all_latex_blocks(latex_list):
    image_paths = []
    for code in latex_list:
        img = render_latex_to_image(f"\\[{code}\\]")  # block display
        if img:
            image_paths.append(img)
    return image_paths