############################
#Just a simple Hello World!#
#By Mikeyjd25              #
############################
DEF BEGIN #Loop forever
LDW GP0 48 #H
CPY GP0 CM0
LDW GP0 65 #e
CPY GP0 CM0
LDW GP0 6C #l
CPY GP0 CM0
CPY GP0 CM0
LDW GP0 6F #o
CPY GP0 CM0
LDW GP0 20 #' '
CPY GP0 CM0
LDW GP0 57 #W
CPY GP0 CM0
LDW GP0 6F #o
CPY GP0 CM0
LDW GP0 72 #r
CPY GP0 CM0
LDW GP0 6C #l
CPY GP0 CM0
LDW GP0 64 #d
CPY GP0 CM0
LDW GP0 21 #!
CPY GP0 CM0
LDW GP0 0A #"Enter"
CPY GP0 CM0


JMP GP0 BEGIN
