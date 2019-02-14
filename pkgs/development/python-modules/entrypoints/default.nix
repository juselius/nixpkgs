{ lib
, buildPythonPackage
, fetchPypi
, configparser
, pytest
, isPy3k
, isPy27
}:

buildPythonPackage rec {
  pname = "entrypoints";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = lib.optional (!isPy3k) configparser;

  checkPhase = let
    # On python2 with pytest 3.9.2 (not with pytest 3.7.4) the test_bad
    # test fails. It tests that a warning (exectly one) is thrown on a "bad"
    # path. The pytest upgrade added some warning, resulting in two warnings
    # being thrown.
    # upstream: https://github.com/takluyver/entrypoints/issues/23
    pyTestArgs = if isPy27 then "-k 'not test_bad'" else "";
  in ''
    py.test ${pyTestArgs} tests
  '';

  meta = {
    description = "Discover and load entry points from installed packages";
    homepage = https://github.com/takluyver/entrypoints;
    license = lib.licenses.mit;
  };
}
