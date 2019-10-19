{
  pkgs
, libunwind
, openssl
, icu
, libuuid
, zlib
, curl
, ...
}:
with pkgs;
let
  dotnet-sdk =
    stdenv.mkDerivation rec {
      version = "3.0.100";
      netCoreVersion = "3.0.0";
      pname = "dotnet-sdk";

      src = fetchurl {
        url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
        sha512 = "3vxhwqv78z8s9pzq19gn0d35g4340m3zvnv70pglk1cgnk02k9hbh51dsf2j6bgcmdxay8q2719ll7baj1sc7n9287vzkqbk8gs6vbn";
      };

      sourceRoot = ".";

      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r ./ $out
        runHook postInstall
      '';

      dontPatchelf = true;

      meta = with stdenv.lib; {
        homepage = https://dotnet.github.io/;
        description = ".NET Core SDK ${version} with .NET Core ${netCoreVersion}";
        platforms = [ "x86_64-linux" ];
        maintainers = with maintainers; [ "jonringer" ];
        license = licenses.mit;
      };
    };
in
  buildFHSUserEnv {
    name = "dotnet";
    targetPkgs = pkgs: with pkgs; [
      dotnet-sdk
      libunwind
      openssl
      icu
      libuuid
      zlib
      curl
    ];
    runScript = "dotnet";
  }

