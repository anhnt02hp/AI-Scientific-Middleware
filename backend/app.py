import re
from flask import Flask, request, jsonify
from latex_renderer import render_latex_to_image

app = Flask(__name__)

@app.route("/render_latex", methods=["POST"])
def render():
    data = request.get_json()
    if not data or "latex_code" not in data:
        return jsonify({"error": "Missing LaTeX code"}), 400

    raw_text = data["latex_code"].strip()

    # Delete all block markdown ```latex ... ```
    raw_text = re.sub(r"```latex(.*?)```", lambda m: m.group(1).strip(), raw_text, flags=re.DOTALL)

    # Find all \documentclass{...} ... \end{document}
    docclass_pattern = re.compile(r"(\\documentclass.*?\\end\{document\})", re.DOTALL)
    docclass_matches = list(docclass_pattern.finditer(raw_text))

    segments = []
    last_index = 0

    for match in docclass_matches:
        # Processing text before \documentclass
        if match.start() > last_index:
            before_text = raw_text[last_index:match.start()]
            segments.extend(parse_inline_latex(before_text))

        full_latex_doc = match.group(1)
        image_base64 = render_latex_to_image(full_latex_doc)
        if image_base64:
            segments.append({"type": "latex", "base64": image_base64})
        else:
            print("⚠️ Failed to render TikZ block.")
            segments.append({"type": "text", "content": full_latex_doc})

        last_index = match.end()

    # Processing the last part
    if last_index < len(raw_text):
        tail = raw_text[last_index:]
        segments.extend(parse_inline_latex(tail))

    return jsonify({"segments": segments})


def parse_inline_latex(text):
    """
    Processing with AI response \(...\), \[...\], $$...$$
    Return list of segments
    """
    pattern = re.compile(r"(\\\((.*?)\\\)|\\\[(.*?)\\\]|\$\$(.*?)\$\$)", re.DOTALL)
    matches = list(pattern.finditer(text))
    if not matches:
        return [{"type": "text", "content": text}]

    segments = []
    last_index = 0

    for match in matches:
        full_match = match.group(1)
        formula = next((g for g in match.groups()[1:] if g is not None), "").strip()

        if match.start() > last_index:
            before_text = text[last_index:match.start()]
            if before_text:
                segments.append({"type": "text", "content": before_text})

        image_base64 = render_latex_to_image(f"\\[{formula}\\]")
        if image_base64:
            segments.append({"type": "latex", "base64": image_base64})
        else:
            print(f"⚠️ Failed to render formula: {formula}")
            segments.append({"type": "text", "content": full_match})

        last_index = match.end()

    if last_index < len(text):
        tail = text[last_index:]
        if tail:
            segments.append({"type": "text", "content": tail})

    return segments


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
