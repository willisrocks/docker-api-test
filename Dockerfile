FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config

#RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
#RUN sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
#RUN sed -i 's/StrictModes yes/StrictModes no/' /etc/ssh/sshd_config

#RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
ENV SESSION_USER testuser
RUN echo "export VISIBLE=now" >> /etc/profile

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh", "$SESSION_USER"]
ENTRYPOINT ["/bin/bash", "-c", "entrypoint.sh", "$SESSION_USER"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
