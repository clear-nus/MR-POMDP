Multi-Reward Partially Observable Markov Decision Processes (MR-POMDP) Test Problems
Harold Soh, 2011, 2012
All Rights Reserved
haroldsoh@imperial.ac.uk
http://www.haroldsoh.com


Description: 

This repository contains MATLAB code to generate test problems used in the papers:

H. Soh and Y. Demiris, Evolving policies for multi-reward partially observable markov decision processes (MR-POMDPs), in Proceedings of the 13th annual conference on Genetic and evolutionary computation, pp. 713-720, 2011.

H. Soh and Y. Demiris, Multi-reward policies for medical applications: anthrax attacks and smart wheelchairs, in MedGEC 2011 : 7th GECCO Workshop on Medical Applications of Genetic and Evolutionary Computation, pp. 471-478, 2011.

Matlab Files contained:

genMLUProblem.m: In the single-objective load-unload problem, a robot has to traverse a corridor to the end where it “loads” an item, which it has to deliver and “unload” at a defined position to receive a reward. Here, we present a 24-state version with up to five unload points, each giving a separate (but equal) reward of 100 (Fig. 4). The robot can only sense the walls around it, giving it seven possible distinct observations. It has four movement actions (up, down, left and right) as well as two actuator actions (load and unload). Each action (except an unload in at the right point) results in a −1 reward. Furthermore, the robot experiences the possibility of sensor and motor failure.

genAdProblem.m: This problem is adapted from the POMDP by Cassandra where the objective was to maximise revenue from the sale of two products on an online-store. An intelligent advertising agent has to decide, based on the webpages that a customer visits, which product he is likely to be interested in and advertise accordingly. The right advertisement can result in a purchase but the wrong advertisement might cause the person to leave the store. We extended this problem to multiple objectives by modelling each product as an separate reward and by adding an additional reputation objective. The reputation of the site would decrease every time a person left the site as a result of a wrong advertisement.

genAnthraxProblem.m: The Multi-objective Anthrax problem. The problem of anthrax outbreak detection was formulated as a POMDP by Izadi and Buckeridge alongside public health experts. This POMDP is comprised of six states (“normal”, “ outbreak day 1” to “outbreak day 4” and “detected”) with two observations (“suspicious” and “not suspicious”) and four actions (“de-clare outbreak”, “review records”, “systematic studies” and “wait”). The original POMDP used a relatively complex reward function that combined the economic costs from multiple sources such as productivity loss, investigative costs, hospitalisation and medical treat- ment. In our multi-objective formulation, we have three-objectives to minimise: loss of life, number of false alarms and cost of investigation (in man-hours).

USAGE:
If you use this in research, please cite the papers:


@inproceedings{Soh:2011:EPM:2001576.2001674,
 author = {Soh, Harold and Demiris, Yiannis},
 title = {Evolving policies for multi-reward partially observable markov decision processes (MR-POMDPs)},
 booktitle = {Proceedings of the 13th annual conference on Genetic and evolutionary computation},
 series = {GECCO '11},
 year = {2011},
 isbn = {978-1-4503-0557-0},
 location = {Dublin, Ireland},
 pages = {713--720},
 numpages = {8},
 url = {http://doi.acm.org/10.1145/2001576.2001674},
 doi = {10.1145/2001576.2001674},
 acmid = {2001674},
 publisher = {ACM},
 address = {New York, NY, USA},
 keywords = {evolutionary algorithm, multi-objective optimization, multi-reward pomdp},
} 

and

@inproceedings{Soh:2011:MPM:2001858.2002036,
 author = {Soh, Harold and Demiris, Yiannis},
 title = {Multi-reward policies for medical applications: anthrax attacks and smart wheelchairs},
 booktitle = {Proceedings of the 13th annual conference companion on Genetic and evolutionary computation},
 series = {GECCO '11},
 year = {2011},
 isbn = {978-1-4503-0690-4},
 location = {Dublin, Ireland},
 pages = {471--478},
 numpages = {8},
 url = {http://doi.acm.org/10.1145/2001858.2002036},
 doi = {10.1145/2001858.2002036},
 acmid = {2002036},
 publisher = {ACM},
 address = {New York, NY, USA},
 keywords = {evolutionary algorithms, medical applications, multi-objective optimization},
}

Additionally, if you use the Anthrax problem, please cite:

@inproceedings{izadi2007decision,
  title={Decision theoretic analysis of improving epidemic detection},
  author={Izadi, M.T. and Buckeridge, D.L.},
  booktitle={AMIA Annual Symposium Proceedings},
  volume={2007},
  pages={354},
  year={2007},
  organization={American Medical Informatics Association}
}


LICENSE:
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products 
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
