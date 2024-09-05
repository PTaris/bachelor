# Program limits

**What Works:**

- The display of islands and their numbering from the CSV file is functioning correctly.
- Clicking on an island changes its color while keeping its number. Clicking on another island to the North, South, West, or East draws a minimal-width bridge, and the count of connected islands is updated.
- Clicking on an island and then on another island three times makes the bridge widen with each click, and the numbering count is updated accordingly.
- Manual entry of levels works as expected for level 10 and similarly for other levels.

**What Doesn't Work:**

- Forbidden moves are not prevented. If a bridge wider than the minimum width is constructed and then another island is clicked, the previous island may display a higher number than expected. This issue is due to the conditions that determine the island's number at the entrance of a bridge based on the bridge's thickness.
- When canceling moves with a right-click, the program still stores the moves, which causes problems.

**Algorithmic Choices:**

- I kept the additional color changes to improve visualization of the steps in my code.
- I used the tag function because self.canvas.delete(line) did not work. This approach is very geometric, and I believe it was a poor choice. For example, working in terms of activations/deactivations for clicks and island features would have been a better approach.
