/*
* SHOP MANAGER MODEL BY MARCO SCARPETTA
*
*  A shop owner aims to estimate the number of sales clerks that are needed
*  to satisfy requests and expectations of his customers.
*  We know that in the average a customers arrives at the shop every Ma
*  minutes, while a clerk needs Ms minutes to serve a customer.
*  Unfortunately, in the shop at most N customers can wait at the same time
*  to be served. We also let K denote the number of clerks working in the shop.
*
*  Let N ∈ {5, 10, 25}, K ∈ {1, 2, 5}, Ma = {1, 2, 5, 10}, and Ms = {1, 2, 5, 10} estimate:
*  - clerks utilisation (fraction of time a clerk is working);
*  - average number of customers served by the shop per time unit;
*  - average number of waiting customers;
*  - average number of customers per time units that cannot enter in the shop.
*/

/*time needed for a new customer arrival*/
param Ma = 1;

/*time needed to serve a customer*/ 
param Ms = 1;

/*constant rate*/ 
const R = 1.0;

/*max number of possible customers*/ 
const T = 20;

species F;                /* potential customer, far from the shop */
species A;                /* customer arrival */
species W;                /* waiting customer */
species S;                /* serving clerk */

species P;                /* available space, at the beginning is instantiated to N */
species C;                /* available clerks, at the beginning is instantiated to K */


rule f_to_a {
    F -[ R/Ma ]-> A
} 

rule a_to_w {
    A|P -[ R ]-> W
}

rule w_to_s {
    W|C -[ R ]-> S
}

rule s_to_f {
    S -[ R/Ms ]-> F|P|C
}

measure E = (#A - (10 - #W - #S)) > 0 ? (#A - (10 - #W - #S)) : 0;

system init(N,K) = F<T>|P<N>|C<K>;


/* 
* 1) In ./sibilla directory run --> cd shell\build\install\sshell\examples\shop_manager 
*    then run: --> python main.py -w 10 -c 5 -a 2 -s 2
*
* 
* 2) In ./sibilla directory run --> cd shell\build\install\sshell\bin
*    or in ./shop_manager directory run --> cd ../../bin
*
*    then start the simulation environment using sh sshell or sshell.bat
*    finally use: --> run "../examples/shop_manager/shop_manager.sib" 
*/
