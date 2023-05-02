import torch
from torch import Tensor
from sklearn.preprocessing import MinMaxScaler, StandardScaler, RobustScaler, Normalizer, QuantileTransformer


def standard(x: Tensor, y: Tensor):
    scaler = StandardScaler()

    x_scaled = scaler.fit_transform(x)
    y_scaled = scaler.fit_transform(y)

    x_scaled = torch.from_numpy(x_scaled)
    y_scaled = torch.from_numpy(y_scaled)

    x_scaled = x_scaled.type(torch.float32)
    y_scaled = y_scaled.type(torch.float32)

    return x_scaled, y_scaled


def min_max(x: Tensor, y: Tensor):
    scaler = MinMaxScaler()

    x_scaled = scaler.fit_transform(x)
    y_scaled = scaler.fit_transform(y)

    x_scaled = torch.from_numpy(x_scaled)
    y_scaled = torch.from_numpy(y_scaled)

    x_scaled = x_scaled.type(torch.float32)
    y_scaled = y_scaled.type(torch.float32)

    return x_scaled, y_scaled


def robust(x: Tensor, y: Tensor):
    scaler = RobustScaler()

    x_scaled = scaler.fit_transform(x)
    y_scaled = scaler.fit_transform(y)

    x_scaled = torch.from_numpy(x_scaled)
    y_scaled = torch.from_numpy(y_scaled)

    x_scaled = x_scaled.type(torch.float32)
    y_scaled = y_scaled.type(torch.float32)

    return x_scaled, y_scaled


def normalize(x: Tensor, y: Tensor):
    scaler = Normalizer()

    x_scaled = scaler.fit_transform(x)
    y_scaled = scaler.fit_transform(y)

    x_scaled = torch.from_numpy(x_scaled)
    y_scaled = torch.from_numpy(y_scaled)

    x_scaled = x_scaled.type(torch.float32)
    y_scaled = y_scaled.type(torch.float32)

    return x_scaled, y_scaled


def quantile(x: Tensor, y: Tensor):
    scaler = QuantileTransformer()

    x_scaled = scaler.fit_transform(x)
    y_scaled = scaler.fit_transform(y)

    x_scaled = torch.from_numpy(x_scaled)
    y_scaled = torch.from_numpy(y_scaled)

    x_scaled = x_scaled.type(torch.float32)
    y_scaled = y_scaled.type(torch.float32)

    return x_scaled, y_scaled
