import 'dart:async';

import 'package:ideahub/model/answer.dart';
import 'package:ideahub/model/comment.dart';
import 'package:ideahub/model/prompt.dart';
import 'package:ideahub/model/prompt_info.dart';
import 'package:ideahub/model/user.dart';
import 'package:ideahub/repository/prompt_repository.dart';
import 'package:ideahub/util/delayer.dart';

class MockPromptRepository implements PromptRepository {
  final _promptInfoController = StreamController<PromptInfo>.broadcast();

  final PromptInfo _promptInfo = PromptInfo(
    items: {},
    page: 0,
    runningUser: User(
      id: '1',
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      interests: const [],
      alias: 'me',
      pictureUrl: '',
    ),
  );

  // ── Seed data ──────────────────────────────────────────────────────────────

  static final List<Prompt> _allPrompts = [
    Prompt(
      id: 'p1',
      content:
          'Write a system prompt for a senior software engineer AI assistant that specializes in code review. It should be thorough, identify potential bugs, suggest best practices, and explain its reasoning clearly.',
      ownerId: 'u1',
      ownerAlias: 'CodeCraft',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(hours: 2)),
      lastModifiedDate: DateTime.now().subtract(const Duration(hours: 2)),
      stars: 142,
      comments: [
        Comment(
          id: 'c1',
          content: 'This is exactly what I needed for my team\'s PR review bot!',
          ownerId: 'u5',
          stars: 12,
          createdDate: DateTime.now().subtract(const Duration(hours: 1)),
          lastModifiedDate: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Comment(
          id: 'c2',
          content: 'Works great with GPT-4. Added a "focus on security" clause and the results got even better.',
          ownerId: 'u8',
          stars: 8,
          createdDate: DateTime.now().subtract(const Duration(minutes: 45)),
          lastModifiedDate: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
      ],
      aiAnswers: [
        const Answer(
          id: 'a1',
          source: 'GPT-4 Turbo',
          category: 'Coding',
          upvotes: 89,
          downvotes: 3,
          ownerId: 'ai',
          content:
              'You are a senior software engineer with 15+ years of experience across multiple languages and paradigms. Your role is to provide thorough, constructive code reviews.\n\nWhen reviewing code:\n1. **Identify bugs first** — look for null pointer exceptions, off-by-one errors, race conditions, and logic flaws.\n2. **Security** — flag SQL injection, XSS, insecure deserialization, and hardcoded credentials.\n3. **Performance** — note O(n²) loops, unnecessary DB calls, memory leaks.\n4. **Maintainability** — suggest clearer naming, proper abstractions, and SOLID principles.\n5. **Always explain WHY** — don\'t just say "this is wrong"; explain the consequence and how to fix it.\n\nFormat responses using code blocks for examples. Be direct but constructive. You are a mentor, not a critic.',
        ),
        const Answer(
          id: 'a2',
          source: 'Claude 3 Opus',
          category: 'Coding',
          upvotes: 76,
          downvotes: 1,
          ownerId: 'ai',
          content:
              'You are an expert code reviewer. Approach every review with the mindset: "How can this code fail in production?"\n\nReview framework:\n- **Correctness** — does it do what it claims? Are edge cases handled?\n- **Robustness** — what happens with null inputs, empty arrays, network failures?\n- **Clarity** — would a junior dev understand this in 6 months?\n- **Test coverage** — are critical paths tested?\n\nFor each issue, provide:\n1. The specific problem\n2. Why it matters\n3. A concrete fix with a code example\n\nKeep a firm but encouraging tone. End each review with a summary: "Biggest risk:", "Quick wins:", and "Overall assessment:".',
        ),
      ],
    ),

    Prompt(
      id: 'p2',
      content:
          'Create a prompt that transforms rough bullet-point notes into a polished, engaging blog post. It should preserve the author\'s voice, add structure, and include a compelling intro and CTA.',
      ownerId: 'u2',
      ownerAlias: 'WordSmith',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(hours: 5)),
      lastModifiedDate: DateTime.now().subtract(const Duration(hours: 5)),
      stars: 98,
      comments: [
        Comment(
          id: 'c3',
          content: 'Saved me hours on content writing. The voice preservation is surprisingly good.',
          ownerId: 'u3',
          stars: 15,
          createdDate: DateTime.now().subtract(const Duration(hours: 3)),
          lastModifiedDate: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
      aiAnswers: [
        const Answer(
          id: 'a3',
          source: 'Claude 3 Opus',
          category: 'Writing',
          upvotes: 54,
          downvotes: 2,
          ownerId: 'ai',
          content:
              'You are a professional content writer and editor. The user will provide rough bullet-point notes. Your job is to transform them into a polished blog post.\n\nRules:\n- **Preserve voice** — infer the author\'s tone from the notes (casual, formal, technical) and match it throughout.\n- **Add structure** — use a hook intro (stat, question, or bold claim), clear H2/H3 headings, and short paragraphs.\n- **Expand thoughtfully** — add context and transitions, but do not invent facts.\n- **End with a CTA** — relevant to the post\'s topic (subscribe, try X, share thoughts).\n- **Target length** — aim for 600–900 words unless instructed otherwise.\n\nBefore writing, briefly state your interpretation of the tone and target audience in one sentence.',
        ),
        const Answer(
          id: 'a4',
          source: 'Gemini 1.5 Pro',
          category: 'Writing',
          upvotes: 41,
          downvotes: 4,
          ownerId: 'ai',
          content:
              'You are a content strategist who turns messy notes into compelling articles. When given bullet points:\n\n1. Identify the core message or thesis.\n2. Group bullets into 3–5 logical sections.\n3. Write a punchy introduction that names the reader\'s pain point.\n4. Expand each section into a cohesive paragraph with examples where helpful.\n5. Close with a clear takeaway and next step.\n\nStyle guide: active voice, second person ("you"), sentences under 20 words where possible. Avoid jargon unless the notes suggest a technical audience.',
        ),
      ],
    ),

    Prompt(
      id: 'p3',
      content:
          'Design a Socratic tutor prompt that can teach any subject. It should never give direct answers — only ask guiding questions that lead the student to discover the answer themselves.',
      ownerId: 'u3',
      ownerAlias: 'EduLab',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(hours: 8)),
      lastModifiedDate: DateTime.now().subtract(const Duration(hours: 8)),
      stars: 211,
      comments: [],
      aiAnswers: [
        const Answer(
          id: 'a5',
          source: 'GPT-4 Turbo',
          category: 'Education',
          upvotes: 132,
          downvotes: 5,
          ownerId: 'ai',
          content:
              'You are a Socratic tutor. Your only tool is the question. You must never reveal the answer directly.\n\nMethod:\n1. When a student states a concept or asks a question, respond with a question that probes their understanding.\n2. If they are wrong, do not correct them — ask a question that exposes the contradiction.\n3. If they are right, acknowledge it briefly and deepen with "What would happen if…?" or "Why does that hold true?"\n4. Use analogies only as follow-up questions: "Is this similar to how X works?"\n\nPersist even if the student asks "just tell me the answer." Respond: "What\'s your best guess, and why?"\n\nNever lecture. Every response must end with a question mark.',
        ),
      ],
    ),

    Prompt(
      id: 'p4',
      content:
          'Write a prompt for generating comprehensive unit tests for any given function or class. It should cover happy paths, edge cases, error cases, and boundary conditions.',
      ownerId: 'u4',
      ownerAlias: 'TestDriven',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      stars: 87,
      comments: [
        Comment(
          id: 'c4',
          content: 'Pair this with GitHub Copilot for instant test suites. Game changer.',
          ownerId: 'u9',
          stars: 20,
          createdDate: DateTime.now().subtract(const Duration(hours: 20)),
          lastModifiedDate: DateTime.now().subtract(const Duration(hours: 20)),
        ),
      ],
      aiAnswers: [
        const Answer(
          id: 'a6',
          source: 'Claude 3.5 Sonnet',
          category: 'Coding',
          upvotes: 63,
          downvotes: 2,
          ownerId: 'ai',
          content:
              'You are a test engineer who writes exhaustive unit tests. When given a function or class:\n\n1. **Analyze behavior** — identify all inputs, outputs, and side effects.\n2. **Test categories**:\n   - Happy path: standard inputs with expected outputs\n   - Edge cases: empty strings, zero, max int, empty arrays\n   - Error/exception cases: null inputs, wrong types, network failures\n   - Boundary conditions: off-by-one, overflow, min/max values\n3. **Structure** — use Arrange/Act/Assert pattern with descriptive test names that read like sentences: `should_returnEmptyList_when_inputIsNull`.\n4. **Mocks** — identify external dependencies and mock them appropriately.\n\nTarget 100% branch coverage. List any assumptions made about the implementation.',
        ),
      ],
    ),

    Prompt(
      id: 'p5',
      content:
          'Create a prompt for a personal finance advisor AI that gives actionable advice based on a user\'s income, expenses, and financial goals. It should be realistic, not overly optimistic.',
      ownerId: 'u5',
      ownerAlias: 'FinanceNerd',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      stars: 73,
      comments: [],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p6',
      content:
          'Write a prompt that makes any LLM analyze business strategy with the rigor of a McKinsey consultant: SWOT, Porter\'s Five Forces, and specific, prioritized recommendations.',
      ownerId: 'u6',
      ownerAlias: 'StrategyPro',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 2)),
      stars: 165,
      comments: [
        Comment(
          id: 'c5',
          content: 'Used this for a board presentation. The structured output was incredibly useful.',
          ownerId: 'u2',
          stars: 31,
          createdDate: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
          lastModifiedDate: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
        ),
      ],
      aiAnswers: [
        const Answer(
          id: 'a7',
          source: 'GPT-4 Turbo',
          category: 'Analysis',
          upvotes: 98,
          downvotes: 6,
          ownerId: 'ai',
          content:
              'You are a senior strategy consultant with 20 years at top-tier firms. When presented with a business situation:\n\n**Phase 1 — Diagnosis (5 min)**\nConduct a SWOT analysis. Be specific: no generic "strong brand" — provide evidence or ask for it.\n\n**Phase 2 — Market Context**\nApply Porter\'s Five Forces. Rate each force (Low/Medium/High) and explain the implication for profitability.\n\n**Phase 3 — Strategic Options**\nPropose exactly 3 strategic options. For each:\n- Name and one-line description\n- Expected impact (revenue/cost/risk)\n- Required resources\n- 12-month implementation milestones\n\n**Phase 4 — Recommendation**\nPick one option. Justify with data. Identify the #1 risk and how to mitigate it.\n\nBe direct. Avoid consultant-speak. If you lack data, name it as an assumption.',
        ),
        const Answer(
          id: 'a8',
          source: 'Gemini 1.5 Pro',
          category: 'Analysis',
          upvotes: 72,
          downvotes: 8,
          ownerId: 'ai',
          content:
              'You are a strategic advisor. Structure every business analysis as follows:\n\n**Executive Summary** (3 bullets max — bottom-line up front)\n\n**Situation Assessment**\n- Market position and trajectory\n- Key competitive dynamics\n- Internal capability gaps\n\n**Critical Issues** (rank by urgency × impact)\n\n**Recommended Actions**\nFor each action: What, Why, Who owns it, KPI to track, deadline.\n\n**Risks & Mitigations**\n\nTone: Board-ready. Concise. No filler. If asked for a "deep dive," go deeper on Phase 3.',
        ),
      ],
    ),

    Prompt(
      id: 'p7',
      content:
          'Design a prompt for a harsh but constructive literary editor. It should critique fiction ruthlessly — pacing, character depth, dialogue authenticity — without discouraging the writer.',
      ownerId: 'u7',
      ownerAlias: 'FictionLab',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
      stars: 54,
      comments: [],
      aiAnswers: [
        const Answer(
          id: 'a9',
          source: 'Claude 3 Opus',
          category: 'Creative',
          upvotes: 44,
          downvotes: 3,
          ownerId: 'ai',
          content:
              'You are a senior fiction editor who has worked with bestselling authors. You respect writers enough to be honest with them.\n\nWhen reviewing a passage or chapter:\n1. **First read** — note your emotional reaction as a reader, not an editor.\n2. **Pacing** — mark where you skimmed or re-read. Both are signals.\n3. **Character** — does each character have a distinct voice? Would you recognize their dialogue without attribution tags?\n4. **Show vs. tell** — highlight every instance of telling emotion. Suggest a sensory replacement.\n5. **Dialogue** — read it aloud. Anything that sounds written, flag it.\n\nDelivery: lead with the one thing that\'s working well. Then be ruthless. End with: "The core worth saving is…" — name the promising element and how to build on it.',
        ),
      ],
    ),

    Prompt(
      id: 'p8',
      content:
          'Write a prompt for debugging code like a senior engineer: systematic, hypothesis-driven, and thorough. It should not jump to solutions — it should first understand the problem completely.',
      ownerId: 'u8',
      ownerAlias: 'BugSlayer',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 3)),
      stars: 119,
      comments: [
        Comment(
          id: 'c6',
          content: 'The "rubber duck" debugging approach this generates is phenomenal.',
          ownerId: 'u1',
          stars: 17,
          createdDate: DateTime.now().subtract(const Duration(days: 2, hours: 18)),
          lastModifiedDate: DateTime.now().subtract(const Duration(days: 2, hours: 18)),
        ),
      ],
      aiAnswers: [
        const Answer(
          id: 'a10',
          source: 'Claude 3.5 Sonnet',
          category: 'Coding',
          upvotes: 81,
          downvotes: 4,
          ownerId: 'ai',
          content:
              'You are a debugging expert. Your process is methodical and hypothesis-driven.\n\nStep 1 — **Understand before solving**\nAsk: What is the expected behavior? What is the actual behavior? When did it start happening?\n\nStep 2 — **Reproduce**\nIdentify the minimum steps to reproduce the bug. If you cannot reproduce it, you cannot fix it.\n\nStep 3 — **Hypothesize**\nList 3 possible root causes, ranked by likelihood. For each: what evidence would confirm or deny it?\n\nStep 4 — **Isolate**\nDivide and conquer: binary search through the call stack. Use logs, assertions, or debugger breakpoints strategically.\n\nStep 5 — **Fix and verify**\nApply the minimal change that fixes the root cause — not the symptom. Then verify it fixes the original reproduction steps and does not break adjacent behavior.',
        ),
      ],
    ),

    Prompt(
      id: 'p9',
      content:
          'Create a prompt for breaking down any project or goal into a clear, actionable task list with time estimates, dependencies, and priorities. Suitable for a solo developer or small team.',
      ownerId: 'u9',
      ownerAlias: 'ProjectPilot',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
      stars: 66,
      comments: [],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p10',
      content:
          'Write a prompt for explaining complex technical concepts to non-technical stakeholders. It should use analogies, avoid jargon, and build understanding progressively without condescension.',
      ownerId: 'u10',
      ownerAlias: 'Bridgebuilder',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 4)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 4)),
      stars: 88,
      comments: [
        Comment(
          id: 'c7',
          content: 'My CTO used this exact approach in our all-hands. Non-devs finally understood microservices!',
          ownerId: 'u6',
          stars: 24,
          createdDate: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
          lastModifiedDate: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        ),
      ],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p11',
      content:
          'Design a prompt for generating cold emails with high reply rates. It should research the recipient\'s context, open with relevance, make a specific ask, and be under 100 words.',
      ownerId: 'u11',
      ownerAlias: 'SalesHacker',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
      stars: 43,
      comments: [],
      aiAnswers: [
        const Answer(
          id: 'a11',
          source: 'GPT-4 Turbo',
          category: 'Writing',
          upvotes: 35,
          downvotes: 5,
          ownerId: 'ai',
          content:
              'You write cold emails that get replies. Rules you never break:\n- Line 1: a specific, researched observation about the recipient (their recent post, product launch, or public statement)\n- Line 2: a single sentence connecting that observation to your value\n- Line 3: a specific, low-friction ask ("15-min call this week?" not "let\'s connect")\n- Total length: 60–90 words\n- No attachments. No "I hope this email finds you well." No wall of text.\n\nBefore writing, ask: What does this person care about right now? Write for that.',
        ),
      ],
    ),

    Prompt(
      id: 'p12',
      content:
          'Write a world-building prompt for a sci-fi novel. It should generate consistent rules for technology, society, and economics — and flag internal contradictions automatically.',
      ownerId: 'u12',
      ownerAlias: 'SciFiForge',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 5)),
      stars: 77,
      comments: [],
      aiAnswers: [
        const Answer(
          id: 'a12',
          source: 'Claude 3 Opus',
          category: 'Creative',
          upvotes: 58,
          downvotes: 2,
          ownerId: 'ai',
          content:
              'You are a science fiction world-building consultant. When given a premise, build a coherent universe across five pillars:\n\n1. **Technology** — define the rules, limits, and costs of key tech. No magic; everything has a trade-off.\n2. **Society** — how does this tech change power structures, labor, and daily life?\n3. **Economics** — what is scarce? What drives trade and conflict?\n4. **Ecology/Physics** — does the setting obey consistent natural laws?\n5. **History** — what caused the current state of affairs? What wars, crises, or discoveries shaped it?\n\nAfter each section, run a **Contradiction Check**: list any facts that conflict with previously established rules. Flag them clearly so the author can resolve them.',
        ),
      ],
    ),

    Prompt(
      id: 'p13',
      content:
          'Create a prompt for summarizing academic research papers into a 5-bullet executive summary that a non-expert can act on, preserving methodology and confidence levels.',
      ownerId: 'u13',
      ownerAlias: 'ResearchDigest',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 5, hours: 8)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 5, hours: 8)),
      stars: 95,
      comments: [],
      aiAnswers: [
        const Answer(
          id: 'a13',
          source: 'Gemini 1.5 Pro',
          category: 'Analysis',
          upvotes: 67,
          downvotes: 3,
          ownerId: 'ai',
          content:
              'You are a research translator. When given an academic paper:\n\n**Output format (exactly):**\n1. **What they studied** — one sentence, plain English\n2. **How they studied it** — sample size, method, key assumptions\n3. **What they found** — the main result in numbers where possible\n4. **Confidence level** — "high confidence" / "preliminary" / "inconclusive" with reasoning\n5. **Actionable implication** — what should a practitioner do differently based on this?\n\n**Rules:**\n- No jargon without a brief definition\n- If confidence is low, say so prominently\n- Note any conflicts of interest or funding sources disclosed in the paper',
        ),
      ],
    ),

    Prompt(
      id: 'p14',
      content:
          'Write a prompt for conducting architecture reviews of software systems: scalability, fault tolerance, security surface, and cost. Output should be a risk-ranked issue list.',
      ownerId: 'u14',
      ownerAlias: 'ArchitectAI',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 6)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 6)),
      stars: 104,
      comments: [
        Comment(
          id: 'c8',
          content: 'Perfect for pre-launch system reviews. Combined with AWS Well-Architected, it\'s unbeatable.',
          ownerId: 'u4',
          stars: 19,
          createdDate: DateTime.now().subtract(const Duration(days: 5, hours: 14)),
          lastModifiedDate: DateTime.now().subtract(const Duration(days: 5, hours: 14)),
        ),
      ],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p15',
      content:
          'Design a prompt for a debate coach AI that can argue any side of any issue with intellectual rigor — identifying the strongest opposition arguments and how to counter them.',
      ownerId: 'u15',
      ownerAlias: 'ArgumentLab',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 7)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 7)),
      stars: 59,
      comments: [],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p16',
      content:
          'Create a prompt for transforming meeting notes into structured action items with owners, deadlines, and success criteria — formatted for a project management tool like Notion or Linear.',
      ownerId: 'u16',
      ownerAlias: 'MeetingFixer',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 7, hours: 5)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 7, hours: 5)),
      stars: 81,
      comments: [],
      aiAnswers: [
        const Answer(
          id: 'a14',
          source: 'Claude 3.5 Sonnet',
          category: 'Productivity',
          upvotes: 55,
          downvotes: 1,
          ownerId: 'ai',
          content:
              'You are a chief of staff who never lets a meeting result in ambiguity. Given raw meeting notes:\n\n1. Extract every decision made and commitment given.\n2. For each action item, format as:\n   - **Task**: [verb + object — specific enough to start immediately]\n   - **Owner**: [name or role]\n   - **Deadline**: [specific date, not "soon"]\n   - **Done when**: [measurable success criterion]\n3. Flag any agenda items that were discussed but not resolved as **Open Questions**.\n4. Summarize the meeting in one sentence: "We decided X, Y, Z."\n\nIf an owner or deadline is not mentioned in the notes, mark it as [UNASSIGNED] / [NO DATE] so the team notices.',
        ),
      ],
    ),

    Prompt(
      id: 'p17',
      content:
          'Write a prompt for generating original startup ideas by combining two unrelated industries and identifying a genuine pain point at their intersection.',
      ownerId: 'u17',
      ownerAlias: 'IdeaMachine',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 8)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 8)),
      stars: 48,
      comments: [],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p18',
      content:
          'Design a prompt for generating social media content calendars for B2B SaaS companies — one month of posts across LinkedIn, X, and newsletters, consistent with a single brand voice.',
      ownerId: 'u18',
      ownerAlias: 'ContentOS',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 8, hours: 10)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 8, hours: 10)),
      stars: 38,
      comments: [],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p19',
      content:
          'Write a prompt for interpreting financial statements (P&L, balance sheet, cash flow) and surfacing the 3 most important signals a CEO should know, in plain language.',
      ownerId: 'u19',
      ownerAlias: 'CFOLens',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 9)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 9)),
      stars: 71,
      comments: [
        Comment(
          id: 'c9',
          content: 'Handed this to a Claude session with our Q3 financials. The runway analysis was spot on.',
          ownerId: 'u5',
          stars: 13,
          createdDate: DateTime.now().subtract(const Duration(days: 8, hours: 16)),
          lastModifiedDate: DateTime.now().subtract(const Duration(days: 8, hours: 16)),
        ),
      ],
      aiAnswers: [],
    ),

    Prompt(
      id: 'p20',
      content:
          'Create a prompt for structured brainstorming: given any challenge, generate 10 solutions across four quadrants — easy/hard × conventional/unconventional — with a rationale for each.',
      ownerId: 'u20',
      ownerAlias: 'ThinkTank',
      ownerPictureUrl: '',
      createdDate: DateTime.now().subtract(const Duration(days: 9, hours: 7)),
      lastModifiedDate: DateTime.now().subtract(const Duration(days: 9, hours: 7)),
      stars: 92,
      comments: [],
      aiAnswers: [
        const Answer(
          id: 'a15',
          source: 'GPT-4 Turbo',
          category: 'Productivity',
          upvotes: 61,
          downvotes: 4,
          ownerId: 'ai',
          content:
              'You are a lateral thinking facilitator. Given any challenge, produce 10 solutions using the **2×2 Innovation Matrix**:\n\n| | Conventional | Unconventional |\n|---|---|---|\n| **Easy to execute** | 2–3 ideas | 2–3 ideas |\n| **Hard to execute** | 1–2 ideas | 1–2 ideas |\n\nFor each idea:\n- One-line description\n- Core insight or mechanism\n- Biggest obstacle\n- Who has done something similar (if anyone)\n\nAfter all 10, pick the one you would bet on and say why in two sentences. Do not default to safe answers — the unconventional quadrants are where the real value lives.',
        ),
      ],
    ),
  ];

  // ── Interface ──────────────────────────────────────────────────────────────

  @override
  Future<PromptInfo> get promptInfoFuture async => _promptInfo.copyWith(
        items: Map.unmodifiable(Map.from(_promptInfo.items)),
        runningUser: _promptInfo.runningUser,
        selectedPrompt: _promptInfo.selectedPrompt,
      );

  @override
  Stream<PromptInfo> get promptInfoStream => _promptInfoController.stream;

  @override
  Future<void> fetchMorePrompts(int page, String userId) {
    return Future.delayed(
      Delayer.delay(),
      () {
        const pageSize = 10;
        final total = _allPrompts.length;

        for (var i = 0; i < pageSize; i++) {
          final sourceIndex = (page * pageSize + i) % total;
          final base = _allPrompts[sourceIndex];
          // Give each repeated cycle a unique id so the map key never collides
          final cycleOffset = ((page * pageSize + i) ~/ total) * total;
          final uniqueId = cycleOffset == 0
              ? base.id
              : '${base.id}_c$cycleOffset';

          if (!_promptInfo.items.containsKey(uniqueId)) {
            _promptInfo.items[uniqueId] = cycleOffset == 0
                ? base
                : base.copyWith(
                    id: uniqueId,
                    createdDate: base.createdDate
                        .subtract(Duration(days: cycleOffset)),
                    lastModifiedDate: base.lastModifiedDate
                        .subtract(Duration(days: cycleOffset)),
                  );
          }
        }

        _promptInfo.page = page;

        _promptInfoController.add(
          _promptInfo.copyWith(
            items: Map.unmodifiable(Map.from(_promptInfo.items)),
            page: _promptInfo.page,
          ),
        );
      },
    );
  }

  @override
  Future<void> fetchPrompt(String id, String userId) {
    return Future.delayed(
      Delayer.delay(),
      () {
        if (_promptInfo.items.containsKey(id)) {
          _promptInfo.selectedPrompt = _promptInfo.items[id]!;
          _promptInfoController.add(
            _promptInfo.copyWith(
              items: Map.unmodifiable(Map.from(_promptInfo.items)),
              selectedPrompt: _promptInfo.selectedPrompt,
            ),
          );
        } else {
          throw StateError('Prompt $id not found.');
        }
      },
    );
  }

  @override
  Future<void> postPrompt(Prompt prompt) async {
    await Future.delayed(Delayer.delay());
    if (_promptInfo.items.containsKey(prompt.id)) {
      throw StateError('Prompt ${prompt.id} already exists.');
    }
    _promptInfo.items[prompt.id] = prompt;
    _promptInfo.selectedPrompt = prompt;
    _promptInfoController.add(
      _promptInfo.copyWith(
        items: Map.unmodifiable(Map.from(_promptInfo.items)),
        selectedPrompt: _promptInfo.selectedPrompt,
      ),
    );
  }

  @override
  Future<void> removePrompt(String? promptId) async {
    await Future.delayed(Delayer.delay());
    if (!_promptInfo.items.containsKey(promptId)) {
      throw StateError('Prompt $promptId does not exist.');
    }
    _promptInfo.items.remove(promptId);
    _promptInfoController.add(
      _promptInfo.copyWith(
        items: Map.unmodifiable(Map.from(_promptInfo.items)),
      ),
    );
  }

  @override
  Future<void> getCurrentUser() async {
    _promptInfoController.add(_promptInfo);
  }

  // ── Unimplemented stubs ────────────────────────────────────────────────────

  @override
  Future<void> addCommentToPrompt(String promptId, Comment comment) =>
      throw UnimplementedError();

  @override
  Future<void> downvoteAnswer(String promptId, String answerId) =>
      throw UnimplementedError();

  @override
  Future<void> fetchMorePromptFromOwner(String ownerId, int page) =>
      throw UnimplementedError();

  @override
  Future<void> incrementPromptStars(String promptId) =>
      throw UnimplementedError();

  @override
  Future<void> postAnswer(String promptId, List<Answer> answers) =>
      throw UnimplementedError();

  @override
  Future<void> removeAnswer(String promptId, String answerId) =>
      throw UnimplementedError();

  @override
  Future<void> removePromptStar(String promptId) => throw UnimplementedError();

  @override
  Future<void> updateAnswer(
          String promptId, String answerId, Answer updatedAnswer) =>
      throw UnimplementedError();

  @override
  Future<void> updateComment(Comment comment) => throw UnimplementedError();

  @override
  Future<void> updatePrompt(Prompt prompt) => throw UnimplementedError();

  @override
  Future<void> upvoteAnswer(String promptId, String answerId) =>
      throw UnimplementedError();

  void dispose() => _promptInfoController.close();
}
