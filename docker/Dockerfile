FROM alpine:3.20

LABEL org.opencontainers.image.title="DummyApp" \
      org.opencontainers.image.description="Dummy container image for signing tests" \
      org.opencontainers.image.version="1.0.0"

COPY hello.sh /hello.sh
RUN chmod +x /hello.sh

CMD ["/hello.sh"]
