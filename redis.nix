{ config, pkgs, ... }:

{ services.redis =
  { enable = true;
    unixSocket = "/tmp/redis.sock";
  };
}
