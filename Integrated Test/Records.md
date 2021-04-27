#### Records:

1. the inner codes: 

   row code: (3,5) RS codes
   column code: (64, 128) LDPC codes

2. BPSK

3. erasure channel:

   ​	(**AWGN channel in progress)

4. the iteration number = 10 for LDPC decoding
   actually, LDPC can have better performance if iteration number is larger.
   However, to observe the impact of RS-codes, we set iter = 10. 

#### Observations:

1. when Pe <=0.35, the inner codes have good performance;

   (Only when LDPC codes have a relatively good performance,

   the RS codes can make sense.)

2. when Pe = 0.4, the inner codes worsen the results

#### Questions:

1. rate of RS code (3,5)/(9,15) ?
2.  encoding process of RS codes
3. under what environments we use such codes ?
4. how to use both codes better

