FROM python:3.11.7-bookworm
RUN apt-get update && apt-get install python3-tk tk-dev -y

COPY ./src /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts
RUN pip install -r requirements.txt
WORKDIR /usr/local/src/myscripts
ENV PYTHONPATH "${PYTHONPATH}:/usr/local/src/myscripts"
EXPOSE 80
CMD ["streamlit", "run", "app.py", "--server.port", "80", "--server.enableXsrfProtection", "false"]