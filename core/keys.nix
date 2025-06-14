{ lib, ... }:

with lib;
{
  options = {
    pgp_enc = mkOption {
      default = "5B2FC8FC2BCF1A58885D6C92B67BBEB336616007";
      type = with types; uniq str;
      description = "Enc key (on yubikey)";
    };
    pgp_sign = mkOption {
      default = "8BC774E4A2EC75073B61A6470BBB1C8B1C3639EE";
      type = with types; uniq str;
      description = "Sign key (on yubikey)";
    };
    pgp_auth_ssh = mkOption {
      default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTyp6w0kARLcBaK7pmctaLgkL3Dq4AxfwgqEJ5Xz+ehNOopak5hauNv9+BCQhhkg9TyPalz2QI54M+IEO6PGe2Vo8NOyjB5KDE9RyLWZBH53yeE5XNC5AdOAQy9yB5JIsLNIR3mVlJBsLr mvHkjzR43A7Sqar2+q7G9z5hf3Tyo6QBBMS2jAdM9Bc8bsRyvcka/uiT51xYvqf97fdk+b4+IVZuDeFcuIv34fXViDEFQCIuSiNO/1ImXAYr/aaG4aC71xTorbOBI2jw5FQTpT4gP0WY0QmL+jBKDiL00FOpsEj5Cirr984hJWrEypeWfRk4 9cNwRV0k9Wp9vpINdQkx cardno:23_350_388";
      type = with types; uniq str;
      description = "Auth key converted to ssh";
    };
    pgp_auth_2_ssh = mkOption {
      default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKbvbmYI5qAUAVgvxHs4wV+Zi6X/M5CMkxf/5qZbXgX7WGwJ+mlhViHaJXiw4p8C4JlOkizPqfnbaNC6w0QjDQiSUJAH4dVwn9GdDqWOEVJsT2M1aMg4tD7fktoDvJ3a1l24jDJyztAIrd2X1hGmKiL7qLNwFvO6D02ba1u+C+OGZJVZKXEhte6WL/5NAKjppWebsvGkEvJ4tuzP8/F2BOZzRVVehhVzeVvZ0irf6TPvlTQZKUnK8B4HcGjoY92Tfp9EfgDnNiVwlghk/csnOKYZjE3+aYanwn6WwzjT1uj1ogo1gRseJvTWCQySVtOYQ3AxoLwXouv5Uv4GpqAExF cardno:20_683_057";
      type = with types; uniq str;
      description = "2nd auth key converted to ssh";
    };
    kestrel_host_age = mkOption {
      default = "age1nyqxtlputuvq97tj3rkmxeedr096vmg873jmqh52he3efcyy4gvsfdncfy";
      type = with types; uniq str;
      description = "Kestrel ssh host key converted to age";
    };
    harrier_host_age = mkOption {
      default = "age18ylcu7jgfpczs58g3k7hr0sjhvhrqmjfzwr0pntxczk5lpgpgy7q3tlxrn";
      type = with types; uniq str;
      description = "Harrier ssh host key converted to age";
    };
    wren_host_age = mkOption {
      default = "age1rr707w76smu6gwph09f3khk7ef35xakm9n9mllhpgkuedpwh7qzsnvqtsm";
      type = with types; uniq str;
      description = "Wren ssh host key converted to age";
    };
    osprey_host_age = mkOption {
      default = "age134juky3eceuevfds5cjs6x5udltddpakqzuyszn8etjv3qvfg9xs4pts7w";
      type = with types; uniq str;
      description = "Wren ssh host key converted to age";
    };
  };
}
