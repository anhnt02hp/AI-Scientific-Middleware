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

    # ✅ Nếu là đoạn LaTeX hoàn chỉnh từ AI (ví dụ TikZ)
    if raw_text.startswith(r"\documentclass"):
        image_base64 = render_latex_to_image(raw_text)
        if image_base64:
            return jsonify({"segments": [{"type": "latex", "base64": image_base64}]}), 200
        else:
            return jsonify({"error": "Failed to render TikZ"}), 500

    # Find all LaTeX code with indication: \(..\), \[..], $$..$$
    pattern = re.compile(r"(\\\((.*?)\\\)|\\\[(.*?)\\\]|\$\$(.*?)\$\$)", re.DOTALL)

    matches = list(pattern.finditer(raw_text))
    if not matches:
        # If not LaTeX => return Text
        return jsonify({"segments": [{"type": "text", "content": raw_text}]}), 200

    segments = []
    last_index = 0

    for match in matches:
        full_match = match.group(1)
        # Get LaTeX code
        formula = next((g for g in match.groups()[1:] if g is not None), "").strip()

        # Add the word of the previous LaTeX code
        if match.start() > last_index:
            before_text = raw_text[last_index:match.start()]
            if before_text:
                segments.append({"type": "text", "content": before_text})

        # Convert LaTeX code to Block to render more better
        image_base64 = render_latex_to_image(f"\\[{formula}\\]")
        if image_base64:
            segments.append({"type": "latex", "base64": image_base64})
        else:
            print(f"⚠️ Failed to render formula: {formula}")
            # If render failed, keep the LaTeX code to show
            segments.append({"type": "text", "content": full_match})

        last_index = match.end()

    # Add text of the last LaTeX code
    if last_index < len(raw_text):
        tail_text = raw_text[last_index:]
        if tail_text:
            segments.append({"type": "text", "content": tail_text})

    return jsonify({"segments": segments})

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
