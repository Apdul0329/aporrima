import torch


class RegressionModel(torch.nn.Module):
    def __init__(self, num: int):
        super().__init__()
        self.linear = torch.nn.Linear(num, 1)

    def forward(self, x):
        return self.linear(x)
