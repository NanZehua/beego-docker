FROM centos:latest

MAINTAINER nanzehua nanzehua@163.com

EXPOSE 8080

#RUN echo "Huawei@123" > paas_pwd.txt
#RUN echo "Huawei@123" >> pass_pwd.txt

RUN groupadd paas
RUN useradd -d /home/paas -g paas -s /bin/sh -m paas
#RUN passwd paas < paas_pwd.txt
#RUN rm paas_pwd.txt

ADD hello.tgz /var/paas/project-hello/

RUN mkdir -p /var/paas/log/
RUN touch /var/paas/log/project-hello.log

RUN chown paas:paas -R /var/paas/
RUN chmod -R 750 /var/paas/

#ENTRYPOINT ["/var/paas/project-hello"]
CMD ["/var/paas/project-hello/hello"]