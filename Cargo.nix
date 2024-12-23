# This file was @generated by cargo2nix 0.11.0.
# It is not intended to be manually edited.

args@{
  release ? true,
  rootFeatures ? [
    "spanshot/default"
  ],
  rustPackages,
  buildRustPackages,
  hostPlatform,
  hostPlatformCpu ? null,
  hostPlatformFeatures ? [],
  target ? null,
  codegenOpts ? null,
  profileOpts ? null,
  cargoUnstableFlags ? null,
  rustcLinkFlags ? null,
  rustcBuildFlags ? null,
  mkRustCrate,
  rustLib,
  lib,
  workspaceSrc,
  ignoreLockHash,
}:
let
  nixifiedLockHash = "85ba7c23d746c05d1111c82c6936075684d447f5570c39928eb592a6f75a8c04";
  workspaceSrc = if args.workspaceSrc == null then ./. else args.workspaceSrc;
  currentLockHash = builtins.hashFile "sha256" (workspaceSrc + /Cargo.lock);
  lockHashIgnored = if ignoreLockHash
                  then builtins.trace "Ignoring lock hash" ignoreLockHash
                  else ignoreLockHash;
in if !lockHashIgnored && (nixifiedLockHash != currentLockHash) then
  throw ("Cargo.nix ${nixifiedLockHash} is out of sync with Cargo.lock ${currentLockHash}")
else let
  inherit (rustLib) fetchCratesIo fetchCrateLocal fetchCrateGit fetchCrateAlternativeRegistry expandFeatures decideProfile genDrvsByProfile;
  profilesByName = {
  };
  rootFeatures' = expandFeatures rootFeatures;
  overridableMkRustCrate = f:
    let
      drvs = genDrvsByProfile profilesByName ({ profile, profileName }: mkRustCrate ({ inherit release profile hostPlatformCpu hostPlatformFeatures target profileOpts codegenOpts cargoUnstableFlags rustcLinkFlags rustcBuildFlags; } // (f profileName)));
    in { compileMode ? null, profileName ? decideProfile compileMode release }:
      let drv = drvs.${profileName}; in if compileMode == null then drv else drv.override { inherit compileMode; };
in
{
  cargo2nixVersion = "0.11.0";
  workspace = {
    spanshot = rustPackages.unknown.spanshot."0.1.0";
  };
  "registry+https://github.com/rust-lang/crates.io-index".itoa."1.0.14" = overridableMkRustCrate (profileName: rec {
    name = "itoa";
    version = "1.0.14";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d75a2a4b1b190afb6f5425f10f6a8f959d2ea0b9c2b1d79553551850539e4674"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".memchr."2.7.4" = overridableMkRustCrate (profileName: rec {
    name = "memchr";
    version = "2.7.4";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "78ca9ab1a0babb1e7d5695e3530886289c18cf2f87ec19a575a0abdce112e3a3"; };
    features = builtins.concatLists [
      [ "alloc" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.92" = overridableMkRustCrate (profileName: rec {
    name = "proc-macro2";
    version = "1.0.92";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "37d3544b3f2748c54e147655edb5025752e2303145b5aefb3c3ea2c78b973bb0"; };
    features = builtins.concatLists [
      [ "proc-macro" ]
    ];
    dependencies = {
      unicode_ident = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-ident."1.0.14" { inherit profileName; }).out;
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".quote."1.0.37" = overridableMkRustCrate (profileName: rec {
    name = "quote";
    version = "1.0.37";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "b5b9d34b8991d19d98081b46eacdd8eb58c6f2b201139f7c5f643cc155a633af"; };
    features = builtins.concatLists [
      [ "proc-macro" ]
    ];
    dependencies = {
      proc_macro2 = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.92" { inherit profileName; }).out;
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".ryu."1.0.18" = overridableMkRustCrate (profileName: rec {
    name = "ryu";
    version = "1.0.18";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "f3cb5ba0dc43242ce17de99c180e96db90b235b8a9fdc9543c96d2209116bd9f"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".serde."1.0.216" = overridableMkRustCrate (profileName: rec {
    name = "serde";
    version = "1.0.216";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "0b9781016e935a97e8beecf0c933758c97a5520d32930e460142b4cd80c6338e"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "derive" ]
      [ "serde_derive" ]
      [ "std" ]
    ];
    dependencies = {
      serde_derive = (buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".serde_derive."1.0.216" { profileName = "__noProfile"; }).out;
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".serde_derive."1.0.216" = overridableMkRustCrate (profileName: rec {
    name = "serde_derive";
    version = "1.0.216";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "46f859dbbf73865c6627ed570e78961cd3ac92407a2d117204c49232485da55e"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
    dependencies = {
      proc_macro2 = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.92" { inherit profileName; }).out;
      quote = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.37" { inherit profileName; }).out;
      syn = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".syn."2.0.90" { inherit profileName; }).out;
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".serde_json."1.0.133" = overridableMkRustCrate (profileName: rec {
    name = "serde_json";
    version = "1.0.133";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "c7fceb2473b9166b2294ef05efcb65a3db80803f0b03ef86a5fc88a2b85ee377"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
    dependencies = {
      itoa = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".itoa."1.0.14" { inherit profileName; }).out;
      memchr = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".memchr."2.7.4" { inherit profileName; }).out;
      ryu = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".ryu."1.0.18" { inherit profileName; }).out;
      serde = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".serde."1.0.216" { inherit profileName; }).out;
    };
  });
  
  "unknown".spanshot."0.1.0" = overridableMkRustCrate (profileName: rec {
    name = "spanshot";
    version = "0.1.0";
    registry = "unknown";
    src = fetchCrateLocal workspaceSrc;
    dependencies = {
      serde = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".serde."1.0.216" { inherit profileName; }).out;
      serde_json = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".serde_json."1.0.133" { inherit profileName; }).out;
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".syn."2.0.90" = overridableMkRustCrate (profileName: rec {
    name = "syn";
    version = "2.0.90";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "919d3b74a5dd0ccd15aeb8f93e7006bd9e14c295087c9896a110f490752bcf31"; };
    features = builtins.concatLists [
      [ "clone-impls" ]
      [ "derive" ]
      [ "parsing" ]
      [ "printing" ]
      [ "proc-macro" ]
    ];
    dependencies = {
      proc_macro2 = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.92" { inherit profileName; }).out;
      quote = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.37" { inherit profileName; }).out;
      unicode_ident = (rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-ident."1.0.14" { inherit profileName; }).out;
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".unicode-ident."1.0.14" = overridableMkRustCrate (profileName: rec {
    name = "unicode-ident";
    version = "1.0.14";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "adb9e6ca4f869e1180728b7950e35922a7fc6397f7b641499e8f3ef06e50dc83"; };
  });
  
}
