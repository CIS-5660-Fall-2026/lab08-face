# Lab 08 - Procedural Face

## Submission
- **Team member:** Yikai Li
- **Shadertoy:** https://www.shadertoy.com/view/fXVXDh


### Task 1 - SURPRISE
`SURPRISE` (0 = calm, 1 = very surprised) drives 5 geometric attributes across 3 facial features, all through `mix()` the same way `EYE_SEPARATION` is used:
- **Eyes:** radius grows from 0.27 to 0.38.
- **Eyebrows:** raised from y = 1.42 to 1.72 (and pulled slightly toward the head so they stay on the surface).
- **Mouth:** goes from a wide, flat slit to a narrow, tall "O" (non-uniform scale on the mouth sphere) and moves slightly down.

### Task 2 - SKEPTICISM
`SKEPTICISM` (0 = neutral, 1 = "really?") is expressed through asymmetry:
- **Eyebrows:** the left brow lifts up while the right brow lowers and its inner end pinches down into a frown.
- **Eyes:** the eye under the frowning brow squints (squashed vertically), while the other stays open, as if sizing someone up.
- **Mouth:** presses into a thinner, narrower line that shifts to one side and tilts, like a noncommittal smirk.

---

Let's practice parameterization! We'll be starting with an oh-so-beautiful gingerbread man face that looks like this:
![image](https://github.com/user-attachments/assets/4707eb0a-b25e-4eda-84e3-3bb336981781)

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

