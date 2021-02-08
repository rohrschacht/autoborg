FROM alpine

RUN apk update && apk upgrade && apk add borgbackup

COPY entry.sh /entry.sh

RUN chmod +x /entry.sh

CMD "/entry.sh"
