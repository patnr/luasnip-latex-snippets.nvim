local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local M = {}

function M.retrieve(is_math, not_math)
  local condition = pipe({ not_math })
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = condition,
  }) --[[@as function]]
  local s = ls.extend_decorator.apply(ls.snippet, {
    condition = condition,
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "verb", name = "Verbatim inline (use any delimiter)" }, "\\verb${1:|}$2$1$0"),
    parse_snippet({ trig = "verbatim", name = "Verbatim env (may contain newlines)" }, "\\begin{verbatim}\n\t$1\n\\end{verbatim}$0"),

    parse_snippet({ trig = "columns", name = "Multicols ('auto' columns -- must usepackage{multicol})" }, "\\begin{multicols}{${1:2}}\n\t$0\n\\end{multicols}"),
    s(
      {
        trig = "columns",
        name = "Columns (for articles)",
      },
      fmta([[
        \begin{minipage}[t]{0.49\textwidth}
          <>
        \end{minipage}
        \hfill\begin{minipage}[t]{0.49\textwidth}
          <>
        \end{minipage}
      ]], {
          i(1),
          i(2),
        }
      )
    ),
    s(
      {
        trig = "columns",
        name = "Columns (for beamer)",
      },
      fmta([[
      \begin{columns}[t,onlytextwidth]
        % onlytextwidth: https://tex.stackexchange.com/a/366422 
        \begin{column}{0.58\textwidth}
          <>
        \end{column}
        \begin{column}{0.39\textwidth}
          <>
        \end{column}
      \end{columns}
      ]], {
          i(1),
          i(2),
        }
      )
    ),

    -- From csquotes. Supports babel, nesting, etc.
    parse_snippet({ trig = "quote_inline", name = "Quote -- inline (package csquotes)" },
      "\\textquote[${1:citation}][${2:punctuation}]{${3:body}}$0"),
    parse_snippet({ trig = "quote_auto", name = "Quote -- inline if short, block if long (package csquotes)" },
      "\\blockquote[${1:citation}][${2:punctuation}]{${3:body}}$0"),
    -- parse_snippet({ trig = "quote_block", name = "Quote -- block (package csquotes)" },
    --   "\\begin{displayquote}\n\t$1\n\\end{displayquote}$0"),
    -- Equivalent (seems like) implementation
    s(
      {
        trig = "quote_block",
        dscr = "Quote -- block (package csquotes)",
      },
      fmta([[
      \begin{displayquote}[${1:citation}][${2:punctuation}]
          <>
      \end{displayquote}
      ]], {
          i(1),
        }
      )
    ),

    -- Builtin
    parse_snippet({ trig = "quote_builtin_inline", name = "Inline quote (builtin)" },
      "\\begin{quote}\n\t$1\n\\end{quote}$0"),
    parse_snippet({ trig = "quote_builtin_block", name = "Block quote (builtin)" },
      "\\begin{quotation}\n\t$1\n\\end{quotation}$0"),

    s(
      {
        trig = "includegraphics",
        dscr = "includegraphics",
      },
      fmta([[\includegraphics[trim={<> <> <> <>},clip,width=<>\textwidth]{<>}]],
        { i(2, "left"),i(3, "bot"),i(4, "right"),i(5, "top"), i(6, "0.95"), i(1), }
      )
    ),

    s(
      {
        trig = "frame",
        dscr = "Beamer frame",
      },
      fmta([[
      \begin{frame}[<>]{<>}
          <>
      \end{frame}
      ]], {
          i(1, [[t/c/b, label=..., fragile, <handout/beamer:0>]]), i(2, "title"), i(3)
        }
      )
    ),

    s(
      {
        trig = "MWE",
        dscr = "Minimal working example",
      },
      fmta([[
        \documentclass[10pt,a4paper]{article}
        \usepackage{parskip}
        % \linespread{1.5}
        \usepackage[top=2.0cm,bottom=1.9cm,left=1.5cm,right=1.5cm]{geometry}
        % \usepackage[authoryear,round,elide,nonamebreak]{natbib}
        % \usepackage[sort,numbers]{natbib}
        \usepackage[utf8]{inputenc}
        \usepackage[french,english]{babel}
        \usepackage[T1]{fontenc}
        \usepackage{lmodern}

        \usepackage{paralist} % Inline
        \setdefaultitem{$\circ$}{$\triangleright$}{$\star$}{-}
        \usepackage{enumitem} % Change list spacing
        \setlist{topsep=2pt,itemsep=2pt,partopsep=2pt, parsep=2pt}

        \usepackage[svgnames]{xcolor}
        \usepackage{soul} % provides \st for strikethrough (cancel)

        \usepackage{amsfonts,amssymb}    % define ensembles
        \usepackage[intlimits]{amsmath}  % intlimits for limits above/below
        \usepackage[]{mathalfa}
        \usepackage{mathrsfs}            % For laplace transform \mathscr{L}
        \usepackage{upgreek}             % Big greek letters
        \usepackage{dsfont}              % Double stroke fonts
        \usepackage{mathtools}           % Delimiter (such as norm) stuff
        \usepackage{relsize}             % Resize maths symbols
        \usepackage{cancel}              % Crossing out stuff
        \usepackage{accents}             % Adds more accents.
        \usepackage{bm}                  % For boldface greek symbols

        \usepackage{float}
        \usepackage[small,bf]{caption}
        \usepackage{mdframed} % Fancy frames
        \usepackage{csquotes}

        \definecolor{mycc}{rgb}{0, 0, 0.45}
        \definecolor{mygreen}{rgb}{0, 0.4, 0}

        \usepackage[pdftex,
          pdftitle={},
          pdfauthor={},
          hyperindex=true,
          colorlinks=true,
          linkcolor=mygreen,
          citecolor=mycc,
              urlcolor=blue,
              ]{hyperref}
        \usepackage[pdftex]{graphicx}
        \usepackage{epstopdf}
        \usepackage[stretch=10]{microtype}
        \usepackage{hyperref}
        \usepackage[doipre={DOI:~}]{uri} % loads "url", if not already loaded

        \graphicspath{{./}{Pics/}}
        \urlstyle{tt}

        \usepackage{cleveref}

        \newcommand\keyw{\textsl} % keyw
        \newcommand{\nospell}[1]{#1}

        \newcommand{\mat}[1]{{\mathbf{{#1}}}}
        % \newcommand{\mat}[1]{{\pmb{\mathsf{#1}}}}
        \newcommand{\vect}[1]{{\bm{#1}}}
        \newcommand{\x}{\vect{x}}
        \newcommand{\y}{\vect{y}}
        \newcommand{\z}{\vect{z}}

        \newcommand*{\myfun}[1]{\mathinner{#1}}
        \newcommand{\ones}[0]{\mathds{1}}

        \newcommand{\TP}{{\mathsf{T}}}
        \newcommand{\tr}{\ensuremath{^{\TP}}}
        \newcommand{\pinvsign}{{+}}
        \newcommand{\pinv}{\ensuremath{^\pinvsign}}
        \newcommand{\pinvtr}{\ensuremath{^{\pinvsign \TP}}}

        \begin{document}
        \title{
            \vspace{-1cm}
            {
                \vspace{-1em}
            Minimal working example
                \vspace{-1em}
            }
        }
        \author{Patrick N. Raanes}
        \date{\vspace{-1em}\today}
        \maketitle
        % \begin{abstract}
        % \end{abstract}
        % \vspace{1em}

        Hello world!
        <>

        %\newpage
        % \bibliographystyle{plainnat}
        % \bibliographystyle{unsrtnat}
        % \bibliographystyle{myabbrvnat}
        % \bibliography{references}
        \end{document}
      ]], {
          i(1),
        }
      )
    ),

  }
end

return M
