Vagrant.configure("2") do |config|


  CONTROLLER_CPUS = 2
  CONTROLLER_MEMORY = 2048

  NODES_CPUS = 2
  NODES_MEMORY = 1024

  NUM_NODES = 2

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
  
    controller.vm.provision "ansible" do |ansible|
    
      ansible.playbook = "provision.yml"
      ansible.groups = {
        "node" => [],
        "controllers" => ["controller"]
      }
      ansible.extra_vars = {
        "controller_ip" => "192.168.56.#{STARTING_IP}"
      }
    end

  
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

      # ANSIBLE - NODE SETUP AND DYNAMIC INVENTORY GENERATION
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "provision.yml"
        ansible.groups = {
          "node" => ["node#{i}"]
        }
        ansible.extra_vars = {
          "node_ip" => node_ip
        }
      end


    end
  end

end 
