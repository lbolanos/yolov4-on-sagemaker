import os
import json
import subprocess

# Sagemaker
HYPER_PARAMETER_JSON_PATH = "/opt/ml/input/config/hyperparameters.json"
TRAIN_DIR = "/opt/ml/input/data/train"
MODEL_DIR = "/opt/ml/input/data/train/model.weights"
VERSION = "v1"

if __name__ == '__main__':
    with open(HYPER_PARAMETER_JSON_PATH, "r") as f:
        hyper_parameters = json.load(f)

    print("---hyper parameters--" + VERSION)
    print(print(json.dumps(hyper_parameters, indent=2)))
    print("----")

    data_file = os.path.join(TRAIN_DIR, hyper_parameters["data_file"])
    cfg_file = os.path.join(TRAIN_DIR, hyper_parameters["cfg_file"])
    if "model_file" in hyper_parameters:
        MODEL_DIR = os.path.join(TRAIN_DIR, hyper_parameters["model_file"])

    if os.path.exists(data_file):
        print(data_file + " exist")
    else:
        print(data_file + " NOT exist")
    if os.path.exists(cfg_file):
        print(cfg_file + " exist")
    else:
        print(cfg_file + " NOT exist")
    if os.path.exists(MODEL_DIR):
        print(MODEL_DIR + " exist")
    else:
        print(MODEL_DIR + " NOT exist")
    # darknet
    subprocess.run(["./darknet", "detector", "train", data_file, cfg_file, MODEL_DIR, "-dont_show", "-map"])

    print("Finalizado")
