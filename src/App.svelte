<script>
  import { onMount } from 'svelte';

  let input = '';
  let output = '';
  let history = [];
  let index = 0;
  const prompt = 'ziimb@terminal:~$ ';
  let terminalElement;
  let inputField;

  let gameActive = false;
  let board = ['', '', '', '', '', '', '', '', ''];
  let currentPlayer = 'X';
  let winner = null;

  const themes = [
    { name: 'default', backgroundColor: '#1e1e1e', color: '#39ff14' },
    // ... other themes
  ];
  let currentThemeIndex = 0;

  const languages = {
    en: {
      help: 'Available commands: help, banner, date, repo, whoami, theme, clear, tictactoe, language',
      // ... other language settings
    },
    // ... other languages
  };
  let currentLanguage = 'en';

  function applyTheme(theme) {
    if (terminalElement) {
      terminalElement.style.backgroundColor = theme.backgroundColor;
      terminalElement.style.color = theme.color;
      localStorage.setItem('currentThemeIndex', currentThemeIndex);
    }
  }

  function printBoard() {
    return `
      ${board[0] || ' '} | ${board[1] || ' '} | ${board[2] || ' '}
     ---+---+---
      ${board[3] || ' '} | ${board[4] || ' '} | ${board[5] || ' '}
     ---+---+---
      ${board[6] || ' '} | ${board[7] || ' '} | ${board[8] || ' '}
    `;
  }

  function resetGame() {
    board = ['', '', '', '', '', '', '', '', ''];
    currentPlayer = 'X';
    gameActive = true;
    winner = null;
    output = `Tic-Tac-Toe game started! Player X's turn. Enter 1-9 to play.\n${printBoard()}\n`;
  }

  function checkWinner() {
    const winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (let condition of winningConditions) {
      const [a, b, c] = condition;
      if (board[a] && board[a] === board[b] && board[a] === board[c]) {
        return board[a];
      }
    }
    return board.includes('') ? null : 'Draw';
  }

  async function handleCommand() {
    history.push(input);
    index = history.length;
    const cmd = input.trim().toLowerCase();
    const parts = cmd.split(' ');

    if (gameActive) {
      const move = parseInt(parts[0]);
      if (!isNaN(move) && move >= 1 && move <= 9 && !board[move - 1]) {
        board[move - 1] = currentPlayer;
        winner = checkWinner();
        if (winner) {
          gameActive = false;
          output = `\n${printBoard()}\n${winner === 'Draw' ? languages[currentLanguage].draw : `Player ${winner} wins!`}\n`;
        } else {
          currentPlayer = currentPlayer === 'X' ? 'O' : 'X';
          output = `${printBoard()}\nPlayer ${currentPlayer}'s turn. Enter 1-9 to play.\n`;
        }
      } else {
        output = `${languages[currentLanguage].invalidMove}\n${printBoard()}\n`;
      }
    } else {
      switch (parts[0]) {
        case 'tictactoe':
          resetGame();
          break;
        case 'clear':
          output = '';
          break;
        // Handle other commands...
        default:
          output += `${languages[currentLanguage].invalidCommand}${cmd}\n`;
      }
    }

    input = '';
  }

  function handleKeyDown(event) {
    if (event.key === 'Enter') {
      handleCommand();
    } else if (event.key === 'Tab') {
      event.preventDefault();
      autocompleteInput();
    }
  }

  onMount(() => {
    terminalElement = document.querySelector('.terminal');
    inputField = document.querySelector('input');

    if (inputField) inputField.focus();

    const savedThemeIndex = localStorage.getItem('currentThemeIndex');
    currentThemeIndex = savedThemeIndex !== null ? parseInt(savedThemeIndex) : 0;
    applyTheme(themes[currentThemeIndex]);
  });
</script>

<div class="terminal">
  <pre>{output}</pre>
  <div class="input-line">
    <span class="prompt">{prompt}</span>
    <input bind:value={input} on:keydown={handleKeyDown} autofocus />
  </div>
</div>

<style>
  /* Styles here remain the same */
</style>
