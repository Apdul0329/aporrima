import torch
from torch import Tensor


def sgd(model: torch.nn.Module, x: Tensor, y: Tensor, lr: float, epochs: int) -> None:
    loss_func = torch.nn.MSELoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)

    for epoch in range(epochs):
        y_pred = model(x)
        loss = loss_func(y_pred, y)

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if epoch % 100 == 0:
            print(f'Epoch {epoch}, Loss {loss.item():.4f}')