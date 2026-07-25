<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Delayed Cursor Effect</title>
  <style>
    body {
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: #0d0d0d;
      color: #fff;
      font-family: monospace;
      cursor: none; /* Hide default cursor */
    }

    a, button {
      cursor: none; /* Hide cursor on interactive items */
    }

    /* Brackets & Dot Styling */
    .cursor-brackets, .cursor-dot {
      position: fixed;
      top: 0;
      left: 0;
      pointer-events: none; /* Allows mouse clicks to pass through */
      transform: translate(-50%, -50%);
      color: #00ff66; /* Bright neon green */
      font-weight: bold;
      font-family: monospace;
      user-select: none;
      z-index: 9999;
      /* Glow effect */
      text-shadow: 0 0 8px rgba(0, 255, 102, 0.6);
    }

    /* Larger Dot */
    .cursor-dot {
      font-size: 28px;
      line-height: 1;
    }

    /* Larger Brackets with CSS transform transitions for smooth expansion */
    .cursor-brackets {
      font-size: 32px;
      line-height: 1;
      display: flex;
      gap: 14px; /* Default inner gap for { • } */
      /* Smooth cubic-bezier transition for the expansion */
      transition: gap 0.3s cubic-bezier(0.25, 1, 0.5, 1), transform 0.3s cubic-bezier(0.25, 1, 0.5, 1);
    }

    /* Hover state: opens up wider: {    •    } */
    .cursor-brackets.hovered {
      gap: 36px; /* Expanded spacing */
      transform: translate(-50%, -50%) scale(1.15); /* Slightly bigger outline */
    }

    /* Test Button */
    .demo-btn {
      padding: 16px 32px;
      font-size: 18px;
      background: transparent;
      color: #00ff66;
      border: 2px solid #00ff66;
      border-radius: 8px;
      font-family: monospace;
      font-weight: bold;
      box-shadow: 0 0 12px rgba(0, 255, 102, 0.2);
    }
  </style>
</head>
<body>

  <!-- Custom Cursor Components -->
  <div class="cursor-brackets" id="brackets">
    <span>{</span>
    <span>}</span>
  </div>
  <div class="cursor-dot" id="dot">•</div>

  <!-- Interactive Test Element -->
  <div>
    <button class="demo-btn">Hover over me</button>
  </div>

  <script>
    const brackets = document.getElementById('brackets');
    const dot = document.getElementById('dot');

    // Mouse coordinates
    let mouseX = 0;
    let mouseY = 0;

    // Position variables for interpolation
    let dotX = 0, dotY = 0;
    let bracketsX = 0, bracketsY = 0;

    // Track cursor move
    document.addEventListener('mousemove', (e) => {
      mouseX = e.clientX;
      mouseY = e.clientY;
    });

    // Linear Interpolation (LERP) helper
    function lerp(start, end, amt) {
      return (1 - amt) * start + amt * end;
    }

    function render() {
      // Dot follows faster (0.22)
      dotX = lerp(dotX, mouseX, 0.22);
      dotY = lerp(dotY, mouseY, 0.22);
      dot.style.left = `${dotX}px`;
      dot.style.top = `${dotY}px`;

      // Brackets follow slower with lag (0.09)
      bracketsX = lerp(bracketsX, mouseX, 0.09);
      bracketsY = lerp(bracketsY, mouseY, 0.09);
      brackets.style.left = `${bracketsX}px`;
      brackets.style.top = `${bracketsY}px`;

      requestAnimationFrame(render);
    }

    // Start 60fps loop
    render();

    // Hover state toggling
    const interactiveElements = document.querySelectorAll('a, button, .demo-btn');

    interactiveElements.forEach((el) => {
      el.addEventListener('mouseenter', () => {
        brackets.classList.add('hovered');
      });
      el.addEventListener('mouseleave', () => {
        brackets.classList.remove('hovered');
      });
    });
  </script>
</body>
</html> 
