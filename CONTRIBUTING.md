# Contributing to the NRE Labs Curriculum

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

Our contribution docs are [located here](https://docs.nrelabs.io/creating-contributing/getting-started). Follow the steps there to bootstrap new content, and open a Pull Request on this repository in order to contribute to the NRE Labs curriculum.

## Curriculum Contribution Standards

**ALL** contributions to the NRE Labs curriculum must be done via a Pull Request, and Pull Requests can only be merged to `master` if the latest commit on that Pull Request's branch satisfies all of these requirements:

1. Passes all Github CI checks
2. Has a valid "accepted" review from a curriculum committer that is different from the PR creator.

These are meant to be done in order. There is no point in conducting a review until all Github CI checks pass. However, once these are passing, the next step is for a reviewer to approve or make suggestions for a second round of edits for your content. Note that the goal for **each and every review** is not to nitpick or make it difficult to contribute to NRE Labs, but rather to ensure the content is reflected in the best light possible. Be patient and willing to adapt to feedback.

Here are a few things that reviewers should be on the lookout for when reviewing new contributions to the curriculum, either for new or existing lessons. If you're contributing to the curriculum, you should be aware of these guidelines, to make the review process much smoother.

### \(Hopefully\) Automated Checks

The following should be automatically checked via the CI tooling, but please double-check, and if the CI tooling missed any of the below, please open an issue on the curriculum repo.

* Is the CHANGELOG updated properly?
* Does `syrctl validate` pass?

### Content Quality

Quality is important in NRE Labs. Here are some general things to be on the lookout for.

* Is the relevance to the learner clear from this lesson? How easy is it for people

  to link this content with their day-to-day?

* Does each lesson stage hit the target length of 5-10 minutes?
* Are the lesson guides easy to follow? Are they well-written,

  with appropriate chunking, punctuation/grammar, and visuals?

### Technical

It's also very important that the curriculum takes maximum advantage of the underlying Antidote platform.

* Does this follow the [Lesson Image Requirements](../../antidote/object-reference/images.md)?
* Does the lesson appropriately take advantage of Antidote's optional features for content depth, like

  optional objective verification or diverse presentations? How about lesson diagrams or videos?

* Do the configuration mechanisms in place for the Endpoints properly reverse/forward based on stage?

