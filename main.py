import os
import sys
import argparse

parser = argparse.ArgumentParser(
    description='Script used to load a population model and perform a simulation using the framework Sibilla.')
parser.add_argument("-w", "--wait", required=False, type=int, default=5,
                    help="Max number of waiting customers in the shop")
parser.add_argument("-c", "--clerks", required=False, type=int, default=2, help="Max number of working clerks")
parser.add_argument("-a", "--arrival", required=False, type=int, default=1,
                    help="Minutes needed for a new customer arrival")
parser.add_argument("-s", "--serve", required=False, type=int, default=1, help="Minutes needed to serve a customer")

if __name__ == "__main__":

    args = vars(parser.parse_args())

    results_dir = "W{}_C{}_A{}_S{}".format(args["wait"], args["clerks"], args["arrival"], args["serve"])
    path = "../shop_manager/results/{}".format(results_dir)

    if not os.path.exists(path):
        os.makedirs(path)

    os.chdir("../../bin")

    command = 'echo module \"population\" \
        load \"../examples/shop_manager/shop_manager.pm\" \
        set \"Ma\" {} \
        set \"Ms\" {} \
        env \
        init \"init\" ({},{}) \
        add all measures \
        measures \
        deadline 480 \
        dt 1.0 \
        replica 100 \
        simulate \
        save output \"../examples/shop_manager/results/{}\" prefix \"shop_Manager\" postfix \"\" \
        quit | sshell'.format(float(args["arrival"]), float(args["serve"]), float(args["wait"]), float(args["clerks"]),
                              results_dir)

    if sys.platform != "win32":
        command = command.replace('\"', '\\"')
        command = command.replace('sshell', 'sh sshell')
        if sys.platform == "linux":
            command = command.replace('(', '\\(')
            command = command.replace(')', '\\)')
        elif sys.platform == "darwin":
            command = command.replace('(', '\(')
            command = command.replace(')', '\)')

    os.system(command)
