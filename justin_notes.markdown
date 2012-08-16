A project doesn't really exist until it has an owner, a budget and a deadline.
Do You Remember has none.
Here's what we came up with:

1. We need to have a definition of a Minimum Releaseable Product. We keep adding features before we've even begun to implement previous ones, and we need to delineate a clear line between which are necessary to the site, and which are enhancements we can progressively roll out.

2. A mobile app should be an enhanced and specialized version of our site. We need to figure out what our site's features are before we can tell an app designer how they can make using them better. Furthermore, we need to codify the design language we're using here (colors, fonts, icons, interface elements and terminology) before we can hand this off to a contractor who is not immersed in our corporate culture. The app is not a separate project from the website; it is an accessory to it.

3. The site still needs memories, and it especially needs well-written ones. We have a certain style we want our memories to be written in: short title, high-quality images, long description, tagged thoroughly. We have a lot of memories that consist of a single low-res image with a title and no description. If possible, we should go through some of these and fix them up, such that the memories we have on the site set the standard for new memories shared by our users. 

4. Michael has a whole company to run -- he shouldn't have to watch us over our shoulders. We can be much more efficient it we work in review cycles.

5. Pixel perfect Photoshop mockups are pointless. I cannot efficiently make a page that looks exactly like a mockup, so leave the fine details to the coding. 

6. The site is counter-intuitive. We need to do user testing.

7. There's not enough communication here. I'm supposed to be in charge of implementing the website design, and I come back after the weekend to find there's two new ways of viewing memory lists.

# Fixes

## general
- javascript efficiency

#login pages
- make lightboxes

## memory/index
- save state of memory display (small/medium/list) in sessions controller
- search-as-you-type

## memory/show
- "do you remember this" tricolor -- what does it do? should it be twitter button style instead? Britt has notes
- follow/unfollow twitter-button style 
- "add" has unexpected actions -- not clear that it means "add a related memory" not "add to your memory bank"
- slider breaks if there are too many elements (replace with previous & next buttons)
- comments need design

## memory/new
- is there a mockup for this?
- generic 1970s = 197X pr 197?
- adding multiple tags

# Features

## Showdown
at its core a great idea, but its not integrated enough into the site. Shouldn't all of the showdown items (or the showdown itself) be linked to specific memories? 

## date slider
slide to arbitrary position on slider
    |-------|-------|-------|---x---|-------|    
    40      50      60      70      80      90

memories displayed:
all generic "1970s"
all 1975
some 1974, 73, 72, and 76, 77, 78, etc.
not bell curve -- way too much work
how does the query work?

## responsive design
multiple header designs: phone - tablet - desktop - widescreen
drag items out of memory bank
photos shuffle around 
no memories - big button to create a new one