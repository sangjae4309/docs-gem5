FROM python:3.11-slim

WORKDIR /workspace

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /workspace

USER sangjae4309
CMD ["/bin/bash"]