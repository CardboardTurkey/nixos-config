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
    kestrel_host_age = mkOption {
      default = "age1u2devzwhhkrc9samflwf20zj72hxu86jn608jkrp3lwrk0na45wqpykyfr";
      type = with types; uniq str;
      description = "Kestrel ssh host key converted to age";
    };
    harrier_host_age = mkOption {
      default = "age1xy7x3pkfpqzkjjqn2gqes3623r7y2ftmgt90x3yr9c82jceydegqt7923l";
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
