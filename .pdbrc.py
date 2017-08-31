import pdb

class Config(pdb.DefaultConfig):
    prompt = 'Ξ '
    use_terminal256formatter = True
    sticky_by_default = False

    def setup(self, pdb):
        # make 'd' an alias to 'down'
        Pdb = pdb.__class__
        Pdb.do_d = Pdb.do_down
