import requests

url = "http://127.0.0.1:5000/render_latex"

raw_text = r"""To compute \( \int x^2 \, dx \), we apply the power rule.
Also, \( \frac{1}{x} \) becomes \( \ln|x| \)."""

response = requests.post(
    url,
    json={"latex_code": raw_text}
)

print("Status code:", response.status_code)
print("Response JSON:")
print(response.json())
