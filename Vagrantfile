Vagrant.configure("2") do |config|

  CONTROLLER_CPUS = 4
  CONTROLLER_MEMORY = 6144

  NODES_CPUS = 4
  NODES_MEMORY = 4096

  NUM_NODES = 1

  STARTING_IP = 3

  # Define the controller
  config.vm.define "controller", primary: true do |controller|
    controller.vm.box         = "bento/ubuntu-24.04"
    controller.vm.box_version = "202404.26.0"
    controller.vm.provider "virtualbox" do |v|
      v.cpus    = CONTROLLER_CPUS
      v.memory  = CONTROLLER_MEMORY
    end
    controller.vm.network "private_network", ip: "192.168.56.#{STARTING_IP}"
    
  end
  
  # Define the nodes
  (1..NUM_NODES).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box         = "bento/ubuntu-24.04"
      node.vm.box_version = "202404.26.0"
      node.vm.hostname = "node#{i}"
      node.vm.provider "virtualbox" do |v|
        v.cpus = NODES_CPUS
        v.memory = NODES_MEMORY
      end
      node_ip = "192.168.56.#{STARTING_IP + i}"
      node.vm.network "private_network", ip: node_ip

    end
  end

  nodes = (1..NUM_NODES).map { |i| "node#{i}" }

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode="2.0"
    ansible.groups = {
      "nodes" => nodes,
      "controllers" => ["controller"]
    }
    ansible.playbook = "provision.yml"
  end

end 
