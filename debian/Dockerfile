apt-get update && apt-get upgrade -y \
&& apt-get install -y \
curl sudo openssh-server openssh-client rsync


/etc/init.d/ssh start

# passwordless ssh
RUN rm /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa

RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


# SSH Key Passwordless
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \

    && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys \
    && /usr/bin/ssh-keygen -A

RUN sed -i '/StrictHostKeyChecking/s/#//g' /etc/ssh/ssh_config \
    && sed -i '/StrictHostKeyChecking/s/ask/no/g' /etc/ssh/ssh_config

# SSH Key Passwordless
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \

    && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys \

    && chmod 0600 ~/.ssh/authorized_keys
