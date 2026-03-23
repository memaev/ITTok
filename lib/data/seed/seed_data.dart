import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/domain/models/topic.dart';

class SeedData {
  SeedData._();

  static const List<Topic> topics = [
    Topic(
      id: 'docker',
      name: 'Docker',
      emoji: '🐳',
      description: 'Containers, images, volumes, networking, and Docker Compose.',
      category: 'DevOps',
    ),
    Topic(
      id: 'python',
      name: 'Python',
      emoji: '🐍',
      description: 'From basics to async, data science, and ML.',
      category: 'Languages',
    ),
    Topic(
      id: 'kotlin',
      name: 'Kotlin',
      emoji: '🎯',
      description: 'Coroutines, Compose, KMP, and modern Android development.',
      category: 'Languages',
    ),
    Topic(
      id: 'cybersecurity',
      name: 'Cyber Security',
      emoji: '🔐',
      description: 'OWASP, vulnerabilities, encryption, and secure coding.',
      category: 'Security',
    ),
    Topic(
      id: 'networking',
      name: 'Networking',
      emoji: '🌐',
      description: 'OSI model, TCP/IP, DNS, subnets, and protocols.',
      category: 'Infrastructure',
    ),
    Topic(
      id: 'git',
      name: 'Git',
      emoji: '🌿',
      description: 'Branching, rebasing, CI/CD, and Git best practices.',
      category: 'Tools',
    ),
  ];

  static final List<ContentCard> cards = [
    // ─── DOCKER ───────────────────────────────────────────────────────────────
    const ContentCard(
      id: 'docker_001',
      topicId: 'docker',
      topicName: 'Docker',
      cardType: CardType.codeSnippet,
      title: 'Multi-stage Dockerfile',
      body:
          'Multi-stage builds dramatically reduce final image size. Build in one stage, copy only the artifacts you need into a minimal runtime image.',
      codeSnippet: '''# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Runtime
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]''',
      language: 'dockerfile',
      tags: ['dockerfile', 'multi-stage', 'optimization'],
      difficulty: Difficulty.intermediate,
      likes: 1842,
    ),

    const ContentCard(
      id: 'docker_002',
      topicId: 'docker',
      topicName: 'Docker',
      cardType: CardType.tip,
      title: 'Always use .dockerignore',
      body:
          'A missing .dockerignore is one of the most common Docker mistakes. Without it, your entire project directory — including node_modules, .git, and secrets — gets sent to the build context, bloating your image and risking security leaks.\n\nAlways include:\n• node_modules/\n• .git/\n• .env\n• **/*.log\n• dist/ (or build/)',
      tags: ['best-practices', 'security', 'optimization'],
      difficulty: Difficulty.beginner,
      likes: 2301,
    ),

    const ContentCard(
      id: 'docker_003',
      topicId: 'docker',
      topicName: 'Docker',
      cardType: CardType.quiz,
      title: 'CMD vs ENTRYPOINT',
      body: 'What is the key difference between CMD and ENTRYPOINT in a Dockerfile?',
      quizOptions: [
        QuizOption(id: 'a', text: 'They are identical — both define the default command', isCorrect: false),
        QuizOption(
          id: 'b',
          text: 'ENTRYPOINT defines the fixed executable; CMD provides default arguments that can be overridden',
          isCorrect: true,
        ),
        QuizOption(id: 'c', text: 'CMD runs at build time; ENTRYPOINT runs at container start', isCorrect: false),
        QuizOption(id: 'd', text: 'ENTRYPOINT only works with shell form, CMD only with exec form', isCorrect: false),
      ],
      quizExplanation:
          'ENTRYPOINT sets the process that always runs (e.g., ["node"]), while CMD sets default arguments (e.g., ["server.js"]). You can override CMD with `docker run myimage other.js`, but overriding ENTRYPOINT requires the --entrypoint flag.',
      tags: ['dockerfile', 'fundamentals'],
      difficulty: Difficulty.beginner,
      likes: 987,
    ),

    const ContentCard(
      id: 'docker_004',
      topicId: 'docker',
      topicName: 'Docker',
      cardType: CardType.codeSnippet,
      title: 'Docker Compose: Node + PostgreSQL',
      body: 'A production-ready docker-compose.yml wiring a Node.js API to PostgreSQL with proper health checks and environment variables.',
      codeSnippet: '''version: "3.9"

services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://user:pass@db:5432/mydb
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  pgdata:''',
      language: 'yaml',
      tags: ['docker-compose', 'postgresql', 'node'],
      difficulty: Difficulty.intermediate,
      likes: 3104,
    ),

    const ContentCard(
      id: 'docker_005',
      topicId: 'docker',
      topicName: 'Docker',
      cardType: CardType.tip,
      title: 'Docker Networking: Bridge vs Host',
      body:
          '🌉 Bridge (default): Each container gets its own network namespace. Containers talk via container names as hostnames. Best for most use cases.\n\n🖥 Host: Container shares the host\'s network namespace. No port mapping needed — the container IS on your network. Maximum performance but no isolation.\n\n📦 None: Complete network isolation. Use for security-critical workloads.\n\nPro tip: In docker-compose, all services share a default bridge network automatically.',
      tags: ['networking', 'bridge', 'host'],
      difficulty: Difficulty.intermediate,
      likes: 1567,
    ),

    const ContentCard(
      id: 'docker_006',
      topicId: 'docker',
      topicName: 'Docker',
      cardType: CardType.codeSnippet,
      title: 'Useful Docker Commands Cheatsheet',
      body: 'The commands you actually use every day.',
      codeSnippet: '''# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View container logs (follow)
docker logs -f <container_id>

# Execute command inside running container
docker exec -it <container_id> sh

# Copy file from container to host
docker cp <container>:/app/file.txt ./file.txt

# Remove all stopped containers
docker container prune

# Remove unused images, volumes, networks
docker system prune -a --volumes

# Inspect container networking
docker inspect <container_id> | grep IPAddress

# Build and tag an image
docker build -t myapp:1.0 .''',
      language: 'bash',
      tags: ['cheatsheet', 'commands', 'cli'],
      difficulty: Difficulty.beginner,
      likes: 4521,
    ),

    // ─── PYTHON ───────────────────────────────────────────────────────────────
    const ContentCard(
      id: 'python_001',
      topicId: 'python',
      topicName: 'Python',
      cardType: CardType.codeSnippet,
      title: 'List Comprehension vs For Loop',
      body:
          'List comprehensions are not just syntactic sugar — they are typically 35-50% faster than equivalent for loops because they are optimised at the bytecode level.',
      codeSnippet: '''# For loop — readable but slower
squares = []
for i in range(1000):
    if i % 2 == 0:
        squares.append(i ** 2)

# List comprehension — faster and idiomatic
squares = [i ** 2 for i in range(1000) if i % 2 == 0]

# Nested comprehension (matrix flattening)
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [num for row in matrix for num in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Dict comprehension
word_lengths = {word: len(word) for word in ["hello", "world", "python"]}
# {'hello': 5, 'world': 5, 'python': 6}''',
      language: 'python',
      tags: ['comprehensions', 'performance', 'idioms'],
      difficulty: Difficulty.beginner,
      likes: 2876,
    ),

    const ContentCard(
      id: 'python_002',
      topicId: 'python',
      topicName: 'Python',
      cardType: CardType.codeSnippet,
      title: 'async/await with asyncio',
      body:
          'Python\'s asyncio enables concurrent I/O without threads. Perfect for web scrapers, API clients, and anything that waits on network or disk.',
      codeSnippet: '''import asyncio
import aiohttp

async def fetch_user(session, user_id: int) -> dict:
    url = f"https://api.example.com/users/{user_id}"
    async with session.get(url) as response:
        return await response.json()

async def fetch_all_users(user_ids: list[int]) -> list[dict]:
    async with aiohttp.ClientSession() as session:
        # Run all requests concurrently
        tasks = [fetch_user(session, uid) for uid in user_ids]
        return await asyncio.gather(*tasks)

# Entry point
async def main():
    users = await fetch_all_users([1, 2, 3, 4, 5])
    print(f"Fetched {len(users)} users")

asyncio.run(main())''',
      language: 'python',
      tags: ['async', 'asyncio', 'concurrency', 'aiohttp'],
      difficulty: Difficulty.intermediate,
      likes: 3421,
    ),

    const ContentCard(
      id: 'python_003',
      topicId: 'python',
      topicName: 'Python',
      cardType: CardType.quiz,
      title: 'What is a Python decorator?',
      body: 'Choose the most accurate description of a Python decorator:',
      quizOptions: [
        QuizOption(id: 'a', text: 'A class that inherits from another class', isCorrect: false),
        QuizOption(
          id: 'b',
          text: 'A function that takes a function as input and returns a modified function',
          isCorrect: true,
        ),
        QuizOption(id: 'c', text: 'A type annotation for function parameters', isCorrect: false),
        QuizOption(id: 'd', text: 'A built-in Python keyword for async functions', isCorrect: false),
      ],
      quizExplanation:
          'Decorators are higher-order functions. @my_decorator above a function is syntactic sugar for func = my_decorator(func). Common use cases: logging, caching (@lru_cache), authentication, retry logic, and Flask/FastAPI route definitions.',
      tags: ['decorators', 'functions', 'meta-programming'],
      difficulty: Difficulty.intermediate,
      likes: 1234,
    ),

    const ContentCard(
      id: 'python_004',
      topicId: 'python',
      topicName: 'Python',
      cardType: CardType.tip,
      title: 'Use dataclasses instead of plain dicts',
      body:
          'Stop using plain dicts for structured data. Python dataclasses give you:\n\n✅ Auto-generated __init__, __repr__, __eq__\n✅ Type hints for IDE support\n✅ Default values and default_factory\n✅ Frozen instances (immutability)\n✅ Field-level metadata\n\nFor even more power, use @dataclass with slots=True (Python 3.10+) for 20-30% memory reduction. Or reach for pydantic for full runtime validation.',
      tags: ['dataclasses', 'best-practices', 'typing'],
      difficulty: Difficulty.beginner,
      likes: 1876,
    ),

    const ContentCard(
      id: 'python_005',
      topicId: 'python',
      topicName: 'Python',
      cardType: CardType.codeSnippet,
      title: 'Type hints with generics',
      body: 'Modern Python (3.10+) has clean, powerful type hints. Use them — your future self and your IDE will thank you.',
      codeSnippet: '''from typing import TypeVar, Generic
from collections.abc import Callable, Sequence

T = TypeVar("T")
U = TypeVar("U")

# Generic function
def first(items: Sequence[T]) -> T | None:
    return items[0] if items else None

# Generic class
class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

# TypeAlias (3.12+)
type UserID = int
type Handler = Callable[[str], bool]

# Practical example
def transform(items: list[T], fn: Callable[[T], U]) -> list[U]:
    return [fn(item) for item in items]

result: list[int] = transform(["hello", "hi"], len)
# [5, 2]''',
      language: 'python',
      tags: ['type-hints', 'generics', 'typing'],
      difficulty: Difficulty.intermediate,
      likes: 2109,
    ),

    const ContentCard(
      id: 'python_006',
      topicId: 'python',
      topicName: 'Python',
      cardType: CardType.tip,
      title: 'The Walrus Operator := explained',
      body:
          'The walrus operator (:=) assigns AND returns a value in the same expression. Introduced in Python 3.8.\n\nBest use cases:\n\n1. While loops: `while chunk := f.read(8192):`\n2. List comprehensions with reuse: `[y for x in data if (y := transform(x)) > 0]`\n3. Avoiding double calls: `if (n := len(items)) > 10: print(n)`\n\nAvoid overusing it — clarity beats cleverness. If your expression is hard to read with :=, use two lines.',
      tags: ['walrus', 'python38', 'syntax'],
      difficulty: Difficulty.intermediate,
      likes: 1543,
    ),

    // ─── KOTLIN ───────────────────────────────────────────────────────────────
    const ContentCard(
      id: 'kotlin_001',
      topicId: 'kotlin',
      topicName: 'Kotlin',
      cardType: CardType.codeSnippet,
      title: 'Coroutines: launch vs async',
      body:
          'launch and async are the two primary coroutine builders. The difference: launch is fire-and-forget; async returns a Deferred you can await.',
      codeSnippet: '''import kotlinx.coroutines.*

// launch: fire and forget, returns Job
fun example1() = runBlocking {
    val job = launch {
        delay(1000L)
        println("World!")
    }
    println("Hello,")
    job.join() // Wait for completion
}

// async: returns Deferred<T>, use .await() to get result
fun example2() = runBlocking {
    val deferred1 = async { fetchUserName() }   // runs concurrently
    val deferred2 = async { fetchUserAge() }    // runs concurrently

    val name = deferred1.await()
    val age = deferred2.await()
    println("\$name is \$age years old")
}

suspend fun fetchUserName(): String {
    delay(500L)
    return "Alice"
}

suspend fun fetchUserAge(): Int {
    delay(300L)
    return 30
}''',
      language: 'kotlin',
      tags: ['coroutines', 'async', 'concurrency'],
      difficulty: Difficulty.intermediate,
      likes: 2934,
    ),

    const ContentCard(
      id: 'kotlin_002',
      topicId: 'kotlin',
      topicName: 'Kotlin',
      cardType: CardType.codeSnippet,
      title: 'Sealed class as Result type',
      body:
          'Replace thrown exceptions and nullable returns with a sealed class Result. This makes error handling explicit, exhaustive, and compile-safe.',
      codeSnippet: '''sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: Throwable, val message: String) : Result<Nothing>()
    data object Loading : Result<Nothing>()
}

// Repository usage
suspend fun fetchUser(id: String): Result<User> {
    return try {
        val user = api.getUser(id)
        Result.Success(user)
    } catch (e: HttpException) {
        Result.Error(e, "Network error: \${e.code()}")
    }
}

// ViewModel usage — exhaustive when()
viewModelScope.launch {
    when (val result = repository.fetchUser("123")) {
        is Result.Loading -> showLoader()
        is Result.Success -> showUser(result.data)
        is Result.Error -> showError(result.message)
    }
}''',
      language: 'kotlin',
      tags: ['sealed-class', 'error-handling', 'result'],
      difficulty: Difficulty.intermediate,
      likes: 3287,
    ),

    const ContentCard(
      id: 'kotlin_003',
      topicId: 'kotlin',
      topicName: 'Kotlin',
      cardType: CardType.quiz,
      title: 'val vs var',
      body: 'What is the difference between val and var in Kotlin?',
      quizOptions: [
        QuizOption(id: 'a', text: 'val is for numbers, var is for strings', isCorrect: false),
        QuizOption(
          id: 'b',
          text: 'val declares a read-only reference; var declares a mutable reference',
          isCorrect: true,
        ),
        QuizOption(id: 'c', text: 'They are identical — just style conventions', isCorrect: false),
        QuizOption(id: 'd', text: 'val is compile-time constant; var is runtime variable', isCorrect: false),
      ],
      quizExplanation:
          'val is like final in Java — the reference cannot be reassigned. However, the object it points to can still be mutated (e.g., a val List can be cleared if it\'s a MutableList). For a true compile-time constant, use const val.',
      tags: ['val', 'var', 'fundamentals'],
      difficulty: Difficulty.beginner,
      likes: 876,
    ),

    const ContentCard(
      id: 'kotlin_004',
      topicId: 'kotlin',
      topicName: 'Kotlin',
      cardType: CardType.tip,
      title: 'Extension functions for cleaner code',
      body:
          'Extension functions let you add methods to existing classes without inheritance or modification. This is one of Kotlin\'s most powerful features for clean, readable code.\n\nCommon patterns:\n• String.toSnakeCase()\n• View.gone() / View.visible()\n• Context.toast(message)\n• List<T>.second() — safe access\n• Flow<T>.collectIn(lifecycleScope)\n\nKey rule: Use extension functions for utility operations. Avoid using them as a substitute for proper class design.',
      tags: ['extensions', 'clean-code', 'kotlin-idioms'],
      difficulty: Difficulty.beginner,
      likes: 2187,
    ),

    const ContentCard(
      id: 'kotlin_005',
      topicId: 'kotlin',
      topicName: 'Kotlin',
      cardType: CardType.codeSnippet,
      title: 'Jetpack Compose: State Hoisting',
      body:
          'State hoisting moves state up to the caller, making composables stateless and reusable. The pattern: pass state down, pass events up.',
      codeSnippet: '''// ❌ Stateful (hard to test, not reusable)
@Composable
fun StatefulCounter() {
    var count by remember { mutableStateOf(0) }
    Button(onClick = { count++ }) {
        Text("Count: \$count")
    }
}

// ✅ Stateless (hoisted state — testable & reusable)
@Composable
fun StatelessCounter(
    count: Int,
    onIncrement: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Button(onClick = onIncrement, modifier = modifier) {
        Text("Count: \$count")
    }
}

// Parent owns and hoists the state
@Composable
fun CounterScreen() {
    var count by remember { mutableStateOf(0) }
    StatelessCounter(
        count = count,
        onIncrement = { count++ },
    )
}''',
      language: 'kotlin',
      tags: ['compose', 'state-hoisting', 'android'],
      difficulty: Difficulty.intermediate,
      likes: 2654,
    ),

    const ContentCard(
      id: 'kotlin_006',
      topicId: 'kotlin',
      topicName: 'Kotlin',
      cardType: CardType.codeSnippet,
      title: 'Flow vs LiveData',
      body: 'Use Flow for everything new. LiveData is lifecycle-aware but limited. Flow is more powerful and works outside Android.',
      codeSnippet: '''// LiveData — Android-only, limited operators
class OldViewModel : ViewModel() {
    private val _user = MutableLiveData<User>()
    val user: LiveData<User> = _user
}

// Flow — multiplatform, rich operators, cold by default
class NewViewModel : ViewModel() {
    // StateFlow: always has a value, hot, replaces LiveData
    private val _user = MutableStateFlow<User?>(null)
    val user: StateFlow<User?> = _user.asStateFlow()

    // SharedFlow: for events (no initial value)
    private val _events = MutableSharedFlow<UiEvent>()
    val events: SharedFlow<UiEvent> = _events.asSharedFlow()

    fun loadUser(id: String) {
        viewModelScope.launch {
            repository.getUserFlow(id)
                .catch { e -> _events.emit(UiEvent.Error(e.message)) }
                .collect { user -> _user.value = user }
        }
    }
}''',
      language: 'kotlin',
      tags: ['flow', 'livedata', 'stateflow', 'viewmodel'],
      difficulty: Difficulty.intermediate,
      likes: 3012,
    ),

    // ─── CYBER SECURITY ───────────────────────────────────────────────────────
    const ContentCard(
      id: 'sec_001',
      topicId: 'cybersecurity',
      topicName: 'Cyber Security',
      cardType: CardType.tip,
      title: 'SQL Injection: Never concatenate user input',
      body:
          'SQL Injection is still the #1 most exploited vulnerability after 25 years. The fix is simple: never build SQL strings with user input.\n\n❌ NEVER:\n`"SELECT * FROM users WHERE name = \'" + userName + "\'"`\n\n✅ ALWAYS use parameterised queries:\n`"SELECT * FROM users WHERE name = ?"` + [userName]\n\nParameterised queries ensure the DB engine treats user input as data, never as SQL syntax. Even a single quote in the input can expose your entire database.',
      tags: ['sql-injection', 'owasp', 'secure-coding'],
      difficulty: Difficulty.beginner,
      likes: 4102,
    ),

    const ContentCard(
      id: 'sec_002',
      topicId: 'cybersecurity',
      topicName: 'Cyber Security',
      cardType: CardType.codeSnippet,
      title: 'JWT Structure Decoded',
      body: 'A JWT is three Base64URL-encoded JSON objects separated by dots: header.payload.signature. The signature is what makes it tamper-evident.',
      codeSnippet: '''// A JWT looks like this:
// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c

// Decoded Header:
{
  "alg": "HS256",   // Signing algorithm
  "typ": "JWT"
}

// Decoded Payload (claims):
{
  "sub": "1234567890",   // Subject (user ID)
  "name": "John Doe",
  "iat": 1516239022,     // Issued at
  "exp": 1516242622,     // Expiry (ALWAYS include!)
  "roles": ["admin"]
}

// ⚠️ SECURITY RULES:
// 1. Never store sensitive data in payload (it's not encrypted, just encoded)
// 2. Always validate expiry (exp claim)
// 3. Use RS256 (asymmetric) for distributed systems, not HS256
// 4. Store tokens in httpOnly cookies, not localStorage (XSS protection)''',
      language: 'javascript',
      tags: ['jwt', 'authentication', 'tokens'],
      difficulty: Difficulty.intermediate,
      likes: 3567,
    ),

    const ContentCard(
      id: 'sec_003',
      topicId: 'cybersecurity',
      topicName: 'Cyber Security',
      cardType: CardType.quiz,
      title: 'What is CSRF?',
      body: 'Which of the following best describes a Cross-Site Request Forgery (CSRF) attack?',
      quizOptions: [
        QuizOption(id: 'a', text: 'Injecting malicious scripts into a webpage viewed by other users', isCorrect: false),
        QuizOption(
          id: 'b',
          text: 'Tricking a victim\'s browser into making authenticated requests to another site without their knowledge',
          isCorrect: true,
        ),
        QuizOption(id: 'c', text: 'Intercepting traffic between client and server via a man-in-the-middle attack', isCorrect: false),
        QuizOption(id: 'd', text: 'Brute-forcing a user\'s session token to hijack their session', isCorrect: false),
      ],
      quizExplanation:
          'CSRF exploits the trust a server has in a user\'s browser. If you\'re logged into bank.com, a malicious site can trick your browser into sending a fund-transfer request to bank.com using your active cookies. Defences: CSRF tokens, SameSite cookie attribute, Origin/Referer header validation.',
      tags: ['csrf', 'web-security', 'owasp'],
      difficulty: Difficulty.intermediate,
      likes: 1243,
    ),

    const ContentCard(
      id: 'sec_004',
      topicId: 'cybersecurity',
      topicName: 'Cyber Security',
      cardType: CardType.tip,
      title: 'OWASP Top 10 — Broken Access Control',
      body:
          'Broken Access Control jumped to #1 in the 2021 OWASP Top 10 (up from #5). 94% of tested applications had some form of it.\n\nWhat it means: Users can act outside their intended permissions.\n\nCommon examples:\n• Modifying a URL parameter to access another user\'s account: /api/users/1234 → /api/users/5678\n• Missing function-level access control in admin endpoints\n• CORS misconfigured to allow untrusted origins\n\nThe fix:\n✅ Deny by default — every endpoint requires explicit permission\n✅ Check access in the backend, never trust the frontend\n✅ Log and alert on access control failures',
      tags: ['owasp', 'access-control', 'authorization'],
      difficulty: Difficulty.intermediate,
      likes: 2876,
    ),

    const ContentCard(
      id: 'sec_005',
      topicId: 'cybersecurity',
      topicName: 'Cyber Security',
      cardType: CardType.codeSnippet,
      title: 'bcrypt password hashing in Python',
      body: 'Never store plain text or MD5/SHA passwords. Use bcrypt, argon2, or scrypt — algorithms specifically designed to be slow.',
      codeSnippet: '''import bcrypt

# Hashing a password
def hash_password(plain_password: str) -> bytes:
    # Work factor of 12 is a good default (adjust based on hardware)
    salt = bcrypt.gensalt(rounds=12)
    hashed = bcrypt.hashpw(plain_password.encode("utf-8"), salt)
    return hashed

# Verifying a password
def verify_password(plain_password: str, hashed: bytes) -> bool:
    return bcrypt.checkpw(plain_password.encode("utf-8"), hashed)

# Usage
hashed_pw = hash_password("MySecurePassword123!")
print(verify_password("MySecurePassword123!", hashed_pw))  # True
print(verify_password("wrongpassword", hashed_pw))          # False

# ⚠️ Why bcrypt?
# 1. Built-in salting — each hash is unique
# 2. Deliberately slow — brute force takes years, not seconds
# 3. Adjustable work factor — scale difficulty as hardware improves''',
      language: 'python',
      tags: ['bcrypt', 'passwords', 'hashing', 'authentication'],
      difficulty: Difficulty.intermediate,
      likes: 3201,
    ),

    const ContentCard(
      id: 'sec_006',
      topicId: 'cybersecurity',
      topicName: 'Cyber Security',
      cardType: CardType.tip,
      title: 'Always validate on the server',
      body:
          'Client-side validation is for UX. Server-side validation is for security. Never confuse the two.\n\nThe attacker does not use your frontend:\n• They send raw HTTP requests via curl or Burp Suite\n• They bypass JavaScript entirely\n• They modify values after your client validates them\n\nEvery single piece of input that reaches your server must be validated:\n✅ Length limits\n✅ Type checking\n✅ Format validation (regex for emails, UUIDs, etc.)\n✅ Range checks (e.g., quantity > 0)\n✅ Whitelist, not blacklist\n\nFrameworks like Pydantic, Joi, Zod, or javax.validation make server-side validation cheap. Use them.',
      tags: ['input-validation', 'secure-coding', 'best-practices'],
      difficulty: Difficulty.beginner,
      likes: 3754,
    ),

    // ─── NETWORKING ───────────────────────────────────────────────────────────
    const ContentCard(
      id: 'net_001',
      topicId: 'networking',
      topicName: 'Networking',
      cardType: CardType.tip,
      title: 'OSI Model — 7 Layers Explained Simply',
      body:
          'The OSI model describes how data travels from one computer to another. Remember it with: "Please Do Not Throw Sausage Pizza Away"\n\n7. Application — HTTP, DNS, SMTP (what your app sees)\n6. Presentation — Encryption, encoding (TLS lives here)\n5. Session — Sessions, authentication state\n4. Transport — TCP/UDP, ports, reliability\n3. Network — IP addresses, routing\n2. Data Link — MAC addresses, switches, frames\n1. Physical — Cables, WiFi signals, bits\n\nIn practice, TCP/IP collapses this to 4 layers: Application, Transport, Internet, Network Access.',
      tags: ['osi', 'fundamentals', 'protocols'],
      difficulty: Difficulty.beginner,
      likes: 5201,
    ),

    const ContentCard(
      id: 'net_002',
      topicId: 'networking',
      topicName: 'Networking',
      cardType: CardType.codeSnippet,
      title: 'DNS Resolution Step by Step',
      body: 'When you type google.com, this is exactly what happens before any HTTP request is made.',
      codeSnippet: r'''# DNS Resolution Process for "google.com"

1. Browser Cache
   └─ Checks local browser DNS cache (~60s TTL)
   └─ If hit → done. If miss → continue.

2. OS Cache / hosts file
   └─ Checks /etc/hosts (Linux/Mac) or C:\Windows\System32\drivers\etc\hosts
   └─ If hit → done. If miss → continue.

3. Recursive Resolver (your ISP or 8.8.8.8)
   └─ Your configured DNS server receives the query
   └─ Checks its own cache. If miss → continue.

4. Root Name Servers (13 clusters worldwide)
   └─ Resolver asks: "Who handles .com?"
   └─ Root server replies: "Ask the .com TLD servers"

5. TLD Name Servers (.com)
   └─ Resolver asks: "Who handles google.com?"
   └─ TLD server replies: "Ask ns1.google.com"

6. Authoritative Name Server (ns1.google.com)
   └─ Returns actual IP: 142.250.80.46

7. Response cached at each level with TTL
   └─ Browser makes HTTP request to 142.250.80.46''',
      language: 'bash',
      tags: ['dns', 'resolution', 'fundamentals'],
      difficulty: Difficulty.intermediate,
      likes: 4102,
    ),

    const ContentCard(
      id: 'net_003',
      topicId: 'networking',
      topicName: 'Networking',
      cardType: CardType.quiz,
      title: 'TCP vs UDP',
      body: 'What is the key difference between TCP and UDP?',
      quizOptions: [
        QuizOption(id: 'a', text: 'TCP is faster; UDP is more reliable', isCorrect: false),
        QuizOption(
          id: 'b',
          text: 'TCP provides reliable, ordered delivery with handshaking; UDP is connectionless and faster with no delivery guarantee',
          isCorrect: true,
        ),
        QuizOption(id: 'c', text: 'TCP is for IPv4; UDP is for IPv6', isCorrect: false),
        QuizOption(id: 'd', text: 'UDP requires a 3-way handshake; TCP does not', isCorrect: false),
      ],
      quizExplanation:
          'TCP (Transmission Control Protocol) does a 3-way handshake (SYN → SYN-ACK → ACK), ensures all packets arrive in order, and retransmits lost packets. Use for HTTP, email, file transfers. UDP is fire-and-forget — faster, lower latency. Use for video streaming, DNS, online gaming, VoIP.',
      tags: ['tcp', 'udp', 'protocols'],
      difficulty: Difficulty.beginner,
      likes: 2345,
    ),

    const ContentCard(
      id: 'net_004',
      topicId: 'networking',
      topicName: 'Networking',
      cardType: CardType.tip,
      title: 'Subnetting: What /24 Actually Means',
      body:
          'CIDR notation (like 192.168.1.0/24) tells you how many hosts are in a network.\n\nThe /24 means 24 bits are the network portion, leaving 8 bits for hosts:\n• 2^8 = 256 total addresses\n• 254 usable (first = network address, last = broadcast)\n\nCommon CIDR blocks:\n• /32 = 1 host (a single IP)\n• /30 = 4 addresses, 2 usable (point-to-point links)\n• /24 = 256 addresses, 254 usable (typical LAN)\n• /16 = 65,536 addresses (large corporate network)\n• /8  = 16.7M addresses (entire class A)\n\nQuick tip: Each step up (e.g., /24 → /23) doubles the number of hosts.',
      tags: ['subnetting', 'cidr', 'ip-addressing'],
      difficulty: Difficulty.intermediate,
      likes: 3102,
    ),

    const ContentCard(
      id: 'net_005',
      topicId: 'networking',
      topicName: 'Networking',
      cardType: CardType.codeSnippet,
      title: 'HTTP Request/Response Anatomy',
      body: 'Every web interaction is an HTTP message. Understanding the structure helps you debug APIs, security issues, and performance.',
      codeSnippet: '''# HTTP Request
GET /api/users/42 HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGci...
Accept: application/json
Content-Type: application/json
User-Agent: MyApp/1.0

# HTTP Response
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Cache-Control: max-age=3600
X-Request-ID: abc-123
ETag: "33a64df5"

{
  "id": 42,
  "name": "Alice",
  "email": "alice@example.com"
}

# Key Status Codes
# 2xx — Success
# 200 OK, 201 Created, 204 No Content
# 3xx — Redirect
# 301 Moved Permanently, 304 Not Modified
# 4xx — Client Error
# 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found
# 5xx — Server Error
# 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable''',
      language: 'http',
      tags: ['http', 'request', 'response', 'status-codes'],
      difficulty: Difficulty.beginner,
      likes: 4521,
    ),

    const ContentCard(
      id: 'net_006',
      topicId: 'networking',
      topicName: 'Networking',
      cardType: CardType.tip,
      title: 'What happens when you type a URL',
      body:
          'The full journey of a URL to a webpage, end to end:\n\n1. DNS lookup → resolve domain to IP address\n2. TCP connection → 3-way handshake with server\n3. TLS handshake → if HTTPS, negotiate encryption (adds ~1 RTT)\n4. HTTP request → browser sends GET request\n5. Server processes → app server handles, queries DB, builds response\n6. HTTP response → server sends HTML, headers, status code\n7. Browser parsing → HTML parsed, DOM built\n8. Sub-resources → browser fetches CSS, JS, images (parallel)\n9. JavaScript execution → scripts run, framework hydrates\n10. Render complete → page displayed\n\nWhere time is lost: DNS (fixable with caching), TLS (fixable with TLS 1.3), render-blocking JS (fixable with async/defer).',
      tags: ['browser', 'http', 'dns', 'performance'],
      difficulty: Difficulty.beginner,
      likes: 6712,
    ),

    // ─── GIT ──────────────────────────────────────────────────────────────────
    const ContentCard(
      id: 'git_001',
      topicId: 'git',
      topicName: 'Git',
      cardType: CardType.codeSnippet,
      title: 'Rebase vs Merge — When to Use Each',
      body:
          'Both integrate changes, but they write history differently. Merge preserves the full history; rebase rewrites it for a linear timeline.',
      codeSnippet: '''# MERGE — preserves all history, creates a merge commit
git checkout main
git merge feature/login
# Result: main has a merge commit showing two parent commits
# ✅ Use for: public/shared branches, preserving exact history
# ❌ Avoid for: personal feature branches (creates noise)

# REBASE — replays commits on top of target, linear history
git checkout feature/login
git rebase main
# Result: feature commits appear to have branched from latest main
# ✅ Use for: cleaning up local feature branches before PR
# ❌ Never rebase shared/public branches (rewrites commit SHAs)

# INTERACTIVE REBASE — squash, reorder, edit commits
git rebase -i HEAD~3
# Opens editor to squash 3 commits into 1 clean commit
# pick a1b2c3 Add login form
# squash d4e5f6 Fix typo in login
# squash g7h8i9 Fix another typo
# → Becomes one commit: "Add login form"

# Golden Rule: Never rebase a branch others are working on!''',
      language: 'bash',
      tags: ['rebase', 'merge', 'workflow'],
      difficulty: Difficulty.intermediate,
      likes: 4201,
    ),

    const ContentCard(
      id: 'git_002',
      topicId: 'git',
      topicName: 'Git',
      cardType: CardType.tip,
      title: 'Conventional Commits',
      body:
          'Conventional Commits is a specification for structured commit messages. It enables automatic changelogs, semantic versioning, and readable history.\n\nFormat: `type(scope): description`\n\nTypes:\n• feat: new feature → bumps MINOR version\n• fix: bug fix → bumps PATCH version\n• breaking: breaking change → bumps MAJOR version\n• docs: documentation only\n• refactor: no feature or fix\n• test: adding or fixing tests\n• chore: build process, dependencies\n• perf: performance improvement\n\nExamples:\n`feat(auth): add OAuth2 Google login`\n`fix(api): return 404 when user not found`\n`feat!: remove deprecated /v1 endpoints` ← breaking change',
      tags: ['commits', 'conventional-commits', 'git-flow'],
      difficulty: Difficulty.beginner,
      likes: 3102,
    ),

    const ContentCard(
      id: 'git_003',
      topicId: 'git',
      topicName: 'Git',
      cardType: CardType.quiz,
      title: 'git reset --hard',
      body: 'What does `git reset --hard HEAD~1` do?',
      quizOptions: [
        QuizOption(id: 'a', text: 'Undoes the last commit but keeps changes staged', isCorrect: false),
        QuizOption(
          id: 'b',
          text: 'Permanently removes the last commit AND discards all its changes from the working directory',
          isCorrect: true,
        ),
        QuizOption(id: 'c', text: 'Creates a new commit that reverts the last commit', isCorrect: false),
        QuizOption(id: 'd', text: 'Stashes the last commit\'s changes', isCorrect: false),
      ],
      quizExplanation:
          'git reset --hard destroys work permanently (without reflog recovery). The three reset modes: --soft (undo commit, keep staged), --mixed (undo commit + unstage, keep files), --hard (undo commit + discard all changes). Use `git revert HEAD` instead if you want a safe undo that preserves history.',
      tags: ['reset', 'undo', 'destructive'],
      difficulty: Difficulty.intermediate,
      likes: 1876,
    ),

    const ContentCard(
      id: 'git_004',
      topicId: 'git',
      topicName: 'Git',
      cardType: CardType.codeSnippet,
      title: 'git stash — Save Work in Progress',
      body: 'git stash is your "save state" button. Use it when you need to switch context without committing half-done work.',
      codeSnippet: '''# Stash all changes (tracked files)
git stash

# Stash with a descriptive message
git stash push -m "WIP: login form validation"

# Include untracked files
git stash push -u -m "WIP: new feature"

# List all stashes
git stash list
# stash@{0}: WIP: login form validation
# stash@{1}: WIP on main: a1b2c3 previous commit

# Apply most recent stash (keeps it in stash list)
git stash apply

# Apply and remove most recent stash
git stash pop

# Apply a specific stash
git stash apply stash@{1}

# Create a branch from a stash
git stash branch feature/login stash@{0}

# Delete a stash
git stash drop stash@{0}

# Delete all stashes
git stash clear''',
      language: 'bash',
      tags: ['stash', 'workflow', 'wip'],
      difficulty: Difficulty.beginner,
      likes: 3409,
    ),

    const ContentCard(
      id: 'git_005',
      topicId: 'git',
      topicName: 'Git',
      cardType: CardType.tip,
      title: 'Write atomic commits',
      body:
          'An atomic commit does exactly one thing. It can be understood, reviewed, reverted, and cherry-picked independently.\n\nAtomic = one logical change:\n✅ "Add password strength validator"\n✅ "Fix null pointer in UserService.getById"\n✅ "Update Dockerfile to Node 20"\n\nNot atomic:\n❌ "Various fixes"\n❌ "WIP"\n❌ "Add feature and also refactor auth and update deps"\n\nWhy it matters:\n• Git bisect finds bugs faster (each commit = one suspect)\n• Code review is focused and reviewable\n• Rollbacks are surgical, not catastrophic\n• History reads like a story\n\nIf you find yourself writing "and" in a commit message, split the commit.',
      tags: ['commits', 'best-practices', 'atomic'],
      difficulty: Difficulty.beginner,
      likes: 4102,
    ),

    const ContentCard(
      id: 'git_006',
      topicId: 'git',
      topicName: 'Git',
      cardType: CardType.codeSnippet,
      title: 'GitHub Actions CI for Flutter',
      body: 'A production GitHub Actions workflow that tests and builds your Flutter app on every push and pull request.',
      codeSnippet: '''name: Flutter CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"
          channel: "stable"
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Analyze
        run: flutter analyze --no-fatal-infos

      - name: Run tests
        run: flutter test --coverage

      - name: Check formatting
        run: dart format --output=none --set-exit-if-changed .

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"
      - run: flutter pub get
      - run: flutter build apk --release''',
      language: 'yaml',
      tags: ['github-actions', 'ci-cd', 'flutter'],
      difficulty: Difficulty.intermediate,
      likes: 3876,
    ),
  ];
}
