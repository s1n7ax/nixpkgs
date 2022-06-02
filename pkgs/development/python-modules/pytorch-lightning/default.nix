{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, future
, fsspec
, packaging
, pytestCheckHook
, pytorch
, pyyaml
, tensorboard
, torchmetrics
, tqdm }:

buildPythonPackage rec {
  pname = "pytorch-lightning";
  version = "1.6.4";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "PyTorchLightning";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-X1xPyE53uo/eWPjQdXiObAnjgWc/Y/K+077Ypi5ZzcE=";
  };

  propagatedBuildInputs = [
    packaging
    future
    fsspec
    pytorch
    pyyaml
    tensorboard
    torchmetrics
    tqdm
  ];

  checkInputs = [ pytestCheckHook ];
  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  doCheck = false;

  pythonImportsCheck = [ "pytorch_lightning" ];

  meta = with lib; {
    description = "Lightweight PyTorch wrapper for machine learning researchers";
    homepage = "https://pytorch-lightning.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
