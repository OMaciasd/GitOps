<<<<<<< HEAD
#C
=======
#E
>>>>>>> acdfc4760420eb25f7047d2e7fd0bef6fa2abf2d
n=0

#F
if n > 4 and n < 7:
    for i in range(n):
        for j in range(n):
            if ((i == 0 or i == n-1) 
            and (j == 0 or j == n-1)) or ((i==1 or i == n-2) 
            and (j == 1 or j == n-2)) or ((i == 2 or i== n-3) 
            and (j == 2 or j == n-3)):
                print('X', end='')
            else:
                print('_', end='')
        print('')

#A		
else:
    print('ERROR')
#OK
