# Using image Python as BASE
FROM python:3.10-slim

# Install nessesary package
RUN apt-get update && apt-get install -y \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-science \
    texlive-pictures \
    imagemagick \
    && apt-get clean

# Allow ImageMagick to read PDFs
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml || true

# Create working-folder in container
WORKDIR /app

# Copy all source code in container
COPY . .

# Install all package of Python
RUN pip install --no-cache-dir -r requirements.txt

# Expose Flask gate
EXPOSE 5000

# Lệnh chạy Flask app
CMD ["python", "app.py"]
