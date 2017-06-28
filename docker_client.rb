require 'docker'

class DockerClient

  def initialize(user, scenario)
    @user = user
    @scenario = scenario
    @container = build_container
    @id = get_id
    @port = ''
    @ip = '0.0.0.0'
  end

  def start
    @container.start
    set_info(@container)
  end

  def stop
    @container.stop
  end

  def id
    @id
  end

  def get_container
    @container
  end

  def to_json
    {user: @user, id: @id, scenario: @scenario, ip: @ip, port: @port}.to_json
  end

  def exec(command)
    @container.exec(command, tty: true)
  end

  def info
    @container.json
  end

  private

  attr_accessor :container

  def build_container
    container = Docker::Container.create(
      'Image' => @scenario,
      'Name' => "#{@user}_#{@scenario}",
      'ExposedPorts' => { '22/tcp' => {} },
      'HostConfig' => {
        'PortBindings' => {
          '22/tcp' => [{}]
        }
      },
      'Env' => ["SESSION_USER=#{@user.to_s}"],
      'Entrypoint' => ["/bin/bash", "-c", "entrypoint.sh", "#{@user.to_s}"],
      'Cmd' => ["/usr/sbin/sshd", "-D"]
    )
    # container.store_file("/test", "Hello world")
    # setup_user(container)
    # container
  end

  def get_id
    @container.id
  end

  def setup_user(container)
    add_user_command = ["useradd", "#{@user}", "-s", "/bin/bash", "-m"]
    container.exec(add_user_command)
  end

  def set_info(container)
    info = container.json['NetworkSettings']['Ports'].values.flatten.first
    @ip = info['HostIp']
    @port = info['HostPort']
  end

end
