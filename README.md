# Lab 08 - Procedural Face

Let's practice parameterization! We'll be starting with an oh-so-beautiful gingerbread man face that looks like this:
![image](https://github.com/user-attachments/assets/4707eb0a-b25e-4eda-84e3-3bb336981781)

## Luke Kwon
Teammates : No Teammates
Shadertoy link: https://www.shadertoy.com/view/73GXD1

### Surprised

<img width="557" height="314" alt="Screenshot 2026-10-28 at 11 30 52 AM" src="https://github.com/user-attachments/assets/3557d580-d8d6-44c5-a8ab-63c091f3ed01" />


### Not Surprised

<img width="557" height="313" alt="Screenshot 2026-10-28 at 11 30 07 AM" src="https://github.com/user-attachments/assets/c152f9fb-cbdb-4159-a3db-d81991dadbf2" />


### Happy

<img width="553" height="316" alt="Screenshot 2026-10-28 at 11 29 37 AM" src="https://github.com/user-attachments/assets/2c14fa2d-4eb1-495e-80a0-dee718938716" />


## Setup
Start by forking [this shadertoy](https://www.shadertoy.com/view/XftyR8)

## Task 1
In the faceSDF function, add a new float parameter called SUPRISE a value between 0 and 1. Copying the way EYE_SEPARATION is used, modify the face such that the gingerbread face looks more or less surprised based on the value of SURPRISE. SURPRISE = 0 should be not very surprised, and SUPRISE = 1.0 should look very surprised. Note that the face shouldn't look broken for any value in that range!
Changing this parameter should change at least 3 geometic attributes of the face and more than one facial feature (just eyebrows are NOT SUFFICIENT).

![image](https://github.com/user-attachments/assets/76d63b1b-f3af-456a-8031-8b8da0abe125)

## Task 2
Your own parameter! Create a new attribute of your choice that maps to a procedural face characteristic in the domain of [0,1]. It SHOULD NOT be a literal attribute, eg. eye-separation or mouth size, but instead a more qualitative, subjective quality that you tie to specific geometic parameters using your design sense. Have fun!

## Extra Credit
In the faceSDF function, create a new float parameter called SADNESS. Follow the same guidelines as outlined in Task 1.
 
## Submission
- Create a pull request to this repository
- In the README, include the names of both your team members
- In the README, create a link to your shader toy solutions
- Make sure your shadertoy is set to UNLISTED or PUBLIC (so we can see them!)

