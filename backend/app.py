import re
from flask import Flask, request, jsonify
from latex_renderer import render_latex_to_image

app = Flask(__name__)

@app.route("/render_latex", methods=["POST"])
def render():
    data = request.get_json()
    if not data or "latex_code" not in data:
        return jsonify({"error": "Missing LaTeX code"}), 400

    raw_text = data["latex_code"]
    # find all latex code in response of AI with beginning of \( ... \)
    formulas = re.findall(r"\\\((.*?)\\\)", raw_text, re.DOTALL)

    if not formulas:
        print("⚠️ No LaTeX formulas found in:", raw_text)
        return jsonify({"error": "No LaTeX formulas found"}), 400

    images = []
    for formula in formulas:
        image_base64 = render_latex_to_image(f"\\[{formula}\\]")  # convert inline to block
        if image_base64:
            images.append(image_base64)
        else:
            print(f"Failed to render: {formula}")

    if not images:
        return jsonify({"error": "Rendering failed"}), 500

    return jsonify({"images": images})

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
