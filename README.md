Verium solo mining with docker
==

A single Ubuntu image containing [veriumd](https://github.com/VeriumReserve/verium) (the headless wallet daemon) and [cpuminer](https://github.com/effectsToCause/veriumMiner).

Solo Mining steps
--

1. Back up your `wallet.dat` file (from `$HOME/Library/Application Support/Verium/` on MacOS, `%appdata%/verium/` on Windows).
2. Copy your `wallet.dat` file to its own directory (e.g. `/veriumdata/wallet.dat`).  This will also become your data directory where the blockchain will persist.
3. Create an overlay network for the wallet and the miner to communicate:

        docker network create verium

4. Launch a `veriumd` container.  This will run veriumd with your `wallet.dat` file in `/root/.verium`, expose the peering and RPC ports, and set the RPC credentials:

        docker run -it --rm --net verium --name veriumd -e RPCPORT=33987 -e RPCUSER=rpcusername -e RPCPASS=rpcpassword -v /veriumdata:/root/.verium -p 36988:36988 -p 33987:33987 launchveriumd

  The first time you run `launchveriumd`, it will check your data directory for the blockchain and config file, and bootstrap them using data downloaded from the vericoin web site.

5. Launch a `cpuminer` container.  This will run the cpuminer, and configure it to connect to the veriumd container:

        docker run -it --rm --net verium --name cpuminer -e RPCPORT=veriumd -e RPCPORT=33987 -e RPCUSER=rpcusername -e RPCPASS=rpcpassword launchcpuminer

  Note that when the `veriumd` first launches, it takes time to bootstrap the blockchain (up to an hour, perhaps longer), and even when the blockchain's already been downloaded, it must also connect to peers.  Subsequent runs don't take long, so don't be alarmed if you see `json_rpc_call` errors for up to a minute.  Be sure to use the same port, username, and password here, as the cpuminer needs those credentials to connect to the veriumd wallet.

Solo Mining steps (simplified)
--
1. Follow steps 1 and 2 above
2. Use docker-compose to automate all of the above steps, and get a self-contained wallet and miner process:

        docker-compose up

  See [docker-compose.yml](docker-compose.yml)

