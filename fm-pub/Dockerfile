FROM python:3.12-slim

ARG INSTALL_AUDIO_AI=true
ARG INSTALL_DIARIZATION=false
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg libmagic1 poppler-utils tesseract-ocr tesseract-ocr-eng tesseract-ocr-rus \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY pyproject.toml ./
RUN mkdir -p app && touch app/__init__.py && \
    pip install --no-cache-dir '.[test]' && \
    if [ "$INSTALL_AUDIO_AI" = "true" ]; then pip install --no-cache-dir '.[audio]'; fi && \
    if [ "$INSTALL_DIARIZATION" = "true" ]; then pip install --no-cache-dir '.[diarization]'; fi

COPY app ./app
RUN pip install --no-cache-dir --no-deps --force-reinstall .
