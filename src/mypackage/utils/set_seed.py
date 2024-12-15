import random
import os


def set_seed(seed: int = 123):
    """set random seed for reproducibility

    Args:
        seed (int, optional): seed value. Defaults to 123.
    """
    try:
        from transformers import set_seed as transformers_set_seed

        transformers_set_seed(seed)
    except ImportError:
        try:
            import tensorflow as tf

            tf.random.set_seed(seed)
        except ImportError:
            pass

        try:
            import torch

            torch.manual_seed(seed)
            if torch.cuda.is_available():
                torch.cuda.manual_seed_all(seed)
            torch.backends.cudnn.deterministic = True
            torch.backends.cudnn.benchmark = False
        except ImportError:
            pass

        try:
            import numpy as np

            np.random.seed(seed)
        except ImportError:
            pass

        random.seed(seed)
        os.environ["PYTHONHASHSEED"] = str(seed)
