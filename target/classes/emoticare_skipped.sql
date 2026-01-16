SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 239 (class 1259 OID 16830)
-- Name: assessment_types; Type: TABLE; Schema: public; Owner: emoticare_user
--

CREATE TABLE public.assessment_types (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    code character varying(20) NOT NULL,
    total_questions integer DEFAULT 0,
    min_score double precision DEFAULT 0,
    max_score double precision DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.assessment_types OWNER TO emoticare_user;

--
-- TOC entry 238 (class 1259 OID 16829)
-- Name: assessment_types_id_seq; Type: SEQUENCE; Schema: public; Owner: emoticare_user
--

CREATE SEQUENCE public.assessment_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assessment_types_id_seq OWNER TO emoticare_user;

--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 238
-- Name: assessment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emoticare_user
--

ALTER SEQUENCE public.assessment_types_id_seq OWNED BY public.assessment_types.id;


--
-- TOC entry 226 (class 1259 OID 16692)
-- Name: badges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.badges (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    icon_url character varying(255),
    criteria_module_id integer
);


ALTER TABLE public.badges OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16691)
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.badges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.badges_id_seq OWNER TO postgres;

--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 225
-- Name: badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.badges_id_seq OWNED BY public.badges.id;


--
-- TOC entry 234 (class 1259 OID 16760)
-- Name: forum_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forum_comments (
    id integer NOT NULL,
    post_id integer,
    user_id integer,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.forum_comments OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16759)
-- Name: forum_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.forum_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.forum_comments_id_seq OWNER TO postgres;

--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 233
-- Name: forum_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.forum_comments_id_seq OWNED BY public.forum_comments.id;


--
-- TOC entry 235 (class 1259 OID 16779)
-- Name: forum_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forum_likes (
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.forum_likes OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16743)
-- Name: forum_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forum_posts (
    id integer NOT NULL,
    user_id integer,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    is_flagged boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_deleted boolean DEFAULT false,
    report_reason text,
    reported_by integer,
    is_reported boolean DEFAULT false
);


ALTER TABLE public.forum_posts OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16742)
-- Name: forum_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.forum_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.forum_posts_id_seq OWNER TO postgres;

--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 231
-- Name: forum_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.forum_posts_id_seq OWNED BY public.forum_posts.id;


--
-- TOC entry 220 (class 1259 OID 16650)
-- Name: modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modules (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    content_url character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.modules OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16649)
-- Name: modules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.modules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.modules_id_seq OWNER TO postgres;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 219
-- Name: modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.modules_id_seq OWNED BY public.modules.id;


--
-- TOC entry 224 (class 1259 OID 16676)
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_questions (
    id integer NOT NULL,
    quiz_id integer,
    question_text text NOT NULL,
    option_a character varying(255) NOT NULL,
    option_b character varying(255) NOT NULL,
    option_c character varying(255) NOT NULL,
    option_d character varying(255) NOT NULL,
    correct_option character(1),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT quiz_questions_correct_option_check CHECK ((correct_option = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar])))
);


ALTER TABLE public.quiz_questions OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16675)
-- Name: quiz_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quiz_questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quiz_questions_id_seq OWNER TO postgres;

--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 223
-- Name: quiz_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quiz_questions_id_seq OWNED BY public.quiz_questions.id;


--
-- TOC entry 222 (class 1259 OID 16661)
-- Name: quizzes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    module_id integer,
    title character varying(255) NOT NULL,
    passing_score integer DEFAULT 70,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quizzes OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16660)
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quizzes_id_seq OWNER TO postgres;

--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 221
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- TOC entry 237 (class 1259 OID 16814)
-- Name: roles; Type: TABLE; Schema: public; Owner: emoticare_user
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.roles OWNER TO emoticare_user;

--
-- TOC entry 236 (class 1259 OID 16813)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: emoticare_user
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO emoticare_user;

--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 236
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emoticare_user
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 230 (class 1259 OID 16725)
-- Name: user_badges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_badges (
    id integer NOT NULL,
    user_id integer,
    badge_id integer,
    earned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_badges OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16724)
-- Name: user_badges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_badges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_badges_id_seq OWNER TO postgres;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 229
-- Name: user_badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_badges_id_seq OWNED BY public.user_badges.id;


--
-- TOC entry 228 (class 1259 OID 16706)
-- Name: user_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_progress (
    id integer NOT NULL,
    user_id integer,
    module_id integer,
    status character varying(20),
    quiz_score integer,
    completed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_progress_status_check CHECK (((status)::text = ANY ((ARRAY['IN_PROGRESS'::character varying, 'COMPLETED'::character varying])::text[])))
);


ALTER TABLE public.user_progress OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16705)
-- Name: user_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_progress_id_seq OWNER TO postgres;

--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 227
-- Name: user_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_progress_id_seq OWNED BY public.user_progress.id;


--
-- TOC entry 218 (class 1259 OID 16636)
-- Name: users; Type: TABLE; Schema: public; Owner: emoticare_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    role_id integer,
    is_active boolean DEFAULT true,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO emoticare_user;

--
-- TOC entry 217 (class 1259 OID 16635)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: emoticare_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO emoticare_user;

--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emoticare_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4826 (class 2604 OID 16833)
-- Name: assessment_types id; Type: DEFAULT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.assessment_types ALTER COLUMN id SET DEFAULT nextval('public.assessment_types_id_seq'::regclass);


--
-- TOC entry 4811 (class 2604 OID 16695)
-- Name: badges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.badges ALTER COLUMN id SET DEFAULT nextval('public.badges_id_seq'::regclass);


--
-- TOC entry 4822 (class 2604 OID 16763)
-- Name: forum_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_comments ALTER COLUMN id SET DEFAULT nextval('public.forum_comments_id_seq'::regclass);


--
-- TOC entry 4816 (class 2604 OID 16746)
-- Name: forum_posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_posts ALTER COLUMN id SET DEFAULT nextval('public.forum_posts_id_seq'::regclass);


--
-- TOC entry 4802 (class 2604 OID 16653)
-- Name: modules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules ALTER COLUMN id SET DEFAULT nextval('public.modules_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 16679)
-- Name: quiz_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions ALTER COLUMN id SET DEFAULT nextval('public.quiz_questions_id_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 16664)
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- TOC entry 4825 (class 2604 OID 16817)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4814 (class 2604 OID 16728)
-- Name: user_badges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges ALTER COLUMN id SET DEFAULT nextval('public.user_badges_id_seq'::regclass);


--
-- TOC entry 4812 (class 2604 OID 16709)
-- Name: user_progress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress ALTER COLUMN id SET DEFAULT nextval('public.user_progress_id_seq'::regclass);


--
-- TOC entry 4798 (class 2604 OID 16639)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5045 (class 0 OID 16830)
-- Dependencies: 239
-- Data for Name: assessment_types; Type: TABLE DATA; Schema: public; Owner: emoticare_user
--

COPY public.assessment_types (id, name, description, code, total_questions, min_score, max_score, created_at) FROM stdin;
1	Generalized Anxiety Disorder 7 (GAD-7)	Screening tool for generalized anxiety disorder.	GAD-7	7	0	21	2026-01-11 12:01:47.075072
2	Patient Health Questionnaire 9 (PHQ-9)	Screening tool for depression severity.	PHQ-9	9	0	27	2026-01-11 12:01:47.075072
\.


--
-- TOC entry 5032 (class 0 OID 16692)
-- Dependencies: 226
-- Data for Name: badges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.badges (id, name, description, icon_url, criteria_module_id) FROM stdin;
1	Fast Learner	Completed first module	badge_fast_learner.png	\N
2	Quiz Master	Scored 100% on a quiz	badge_quiz_master.png	\N
3	Anxiety Warrior	Successfully completed the Understanding Anxiety module.	🛡️	1
4	Zen Master	Completed the Stress Management module.	🧘	2
\.


--
-- TOC entry 5040 (class 0 OID 16760)
-- Dependencies: 234
-- Data for Name: forum_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forum_comments (id, post_id, user_id, content, created_at) FROM stdin;
1	1	4	yay!	2026-01-11 12:27:16.369162
\.


--
-- TOC entry 5041 (class 0 OID 16779)
-- Dependencies: 235
-- Data for Name: forum_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forum_likes (post_id, user_id, created_at) FROM stdin;
1	4	2026-01-11 12:27:09.870116
\.


--
-- TOC entry 5038 (class 0 OID 16743)
-- Dependencies: 232
-- Data for Name: forum_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forum_posts (id, user_id, title, content, is_flagged, created_at, updated_at, is_deleted, report_reason, reported_by, is_reported) FROM stdin;
1	1	Welcome to the Community!	Feel free to share your experiences and ask questions here. We are in this together.	f	2026-01-11 12:22:52.124072	2026-01-11 12:22:52.124072	f	\N	\N	f
2	4	sleep	i am having hard time sleeping	f	2026-01-11 12:27:04.510734	2026-01-11 12:27:04.510734	f	\N	\N	f
3	4	blah blah blah	ihdfshfc	f	2026-01-11 13:51:56.786344	2026-01-11 13:51:56.786344	t	irrelevant	\N	t
\.


--
-- TOC entry 5026 (class 0 OID 16650)
-- Dependencies: 220
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modules (id, title, description, content_url, created_at, updated_at) FROM stdin;
1	Understanding Anxiety	Learn the basics of anxiety, its symptoms, and coping mechanisms.	https://youtu.be/ah4Hnrz3CDg?si=PTEVeR17HlJ62p-K	2026-01-11 12:22:52.124072	2026-01-11 13:05:26.345467
2	Managing Stress	Effective strategies to manage daily stress and improve well-being.	https://youtu.be/hnpQrMqDoqE?si=D_YAOsTu2SQtiDgS	2026-01-11 12:22:52.124072	2026-01-11 13:05:57.752713
3	insomnia & its effect	\r\n## 🌙 What Is Insomnia?\r\n- **Definition:** Insomnia is a sleep disorder that disrupts your ability to get enough quality rest. It can be **acute (short-term)**, lasting a few nights to weeks, or **chronic (long-term)**, occurring at least three nights a week for three months or more.  \r\n- **Impact:** Beyond feeling tired, insomnia can affect concentration, mood, and even long-term health, linking to issues like high blood pressure, depression, and weakened immunity.  \r\n- **Prevalence:** Around **10% of the global population** experiences insomnia severe enough to be considered a medical condition.  \r\n\r\n---\r\n\r\n## 🔎 Causes of Insomnia\r\n- **Stress & Anxiety:** Worries about work, relationships, or health often keep the mind racing at night.  \r\n- **Poor Sleep Habits:** Irregular schedules, late-night screen use, or caffeine close to bedtime.  \r\n- **Medical Conditions:** Chronic pain, asthma, or other illnesses can interfere with sleep.  \r\n- **Medications:** Some prescriptions (like stimulants or steroids) may cause sleep disturbances.  \r\n- **Lifestyle Factors:** Jet lag, shift work, or inconsistent routines.  \r\n\r\n---\r\n\r\n## ✅ How to Fix Insomnia\r\nHere are evidence-based strategies to improve sleep quality:\r\n\r\n| Strategy | How It Helps |\r\n|----------|--------------|\r\n| **Sleep Hygiene** | Stick to a consistent bedtime, keep your room dark and cool, and avoid screens before bed. |\r\n| **Relaxation Techniques** | Meditation, deep breathing, or gentle yoga can calm the mind. |\r\n| **Limit Stimulants** | Reduce caffeine, nicotine, and alcohol, especially in the evening. |\r\n| **Physical Activity** | Regular exercise promotes better sleep, but avoid intense workouts right before bed. |\r\n| **Cognitive Behavioral Therapy (CBT-I)** | A proven treatment that helps reframe negative thoughts about sleep. |\r\n| **Medical Support** | In persistent cases, doctors may prescribe short-term sleep aids or address underlying conditions. |\r\n\r\n---\r\n\r\n## ⚠️ Risks & Considerations\r\n- **Quick fixes like sleeping pills** may help short-term but can cause dependency if misused.  \r\n- **Ignoring insomnia** can lead to chronic fatigue, poor performance, and increased risk of health problems.  \r\n- **Professional help** is important if insomnia lasts more than a few weeks or significantly impacts daily life.  \r\n\r\n	https://youtu.be/j5Sl8LyI7k8?si=u-ccnHdOAAAPPrHH	2026-01-11 13:11:24.799915	2026-01-11 13:11:24.799915
\.


--
-- TOC entry 5030 (class 0 OID 16676)
-- Dependencies: 224
-- Data for Name: quiz_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_questions (id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option, created_at) FROM stdin;
1	1	What is a common physical symptom of anxiety?	Feeling calm	Rapid heartbeat	Slow breathing	Sleepiness	B	2026-01-11 12:22:52.124072
2	1	Which is a recommended coping strategy?	Ignoring it	Deep breathing	Drinking caffeine	Isolating yourself	B	2026-01-11 12:22:52.124072
\.


--
-- TOC entry 5028 (class 0 OID 16661)
-- Dependencies: 222
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quizzes (id, module_id, title, passing_score, created_at, updated_at) FROM stdin;
1	1	Anxiety Basics Quiz	70	2026-01-11 12:22:52.124072	2026-01-11 12:22:52.124072
2	2	Stress Management Quiz	70	2026-01-11 12:22:52.124072	2026-01-11 12:22:52.124072
3	3	insomnia & its effect	70	2026-01-11 13:26:27.987118	2026-01-11 13:26:27.987118
\.


--
-- TOC entry 5043 (class 0 OID 16814)
-- Dependencies: 237
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: emoticare_user
--

COPY public.roles (id, name, description) FROM stdin;
1	Student	Undergraduate or graduate student
2	Faculty	Academic faculty member
3	Professional	Mental health professional
4	Admin	System administrator
\.


--
-- TOC entry 5036 (class 0 OID 16725)
-- Dependencies: 230
-- Data for Name: user_badges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_badges (id, user_id, badge_id, earned_at) FROM stdin;
1	4	3	2026-01-11 12:26:13.82985
\.


--
-- TOC entry 5034 (class 0 OID 16706)
-- Dependencies: 228
-- Data for Name: user_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_progress (id, user_id, module_id, status, quiz_score, completed_at, created_at) FROM stdin;
1	4	1	COMPLETED	100	2026-01-11 12:26:13.82985	2026-01-11 12:26:14.036028
3	4	3	IN_PROGRESS	0	\N	2026-01-11 13:51:13.593109
2	4	2	IN_PROGRESS	0	\N	2026-01-11 12:36:40.955024
\.


--
-- TOC entry 5024 (class 0 OID 16636)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: emoticare_user
--

COPY public.users (id, username, email, password, created_at, role_id, is_active, updated_at) FROM stdin;
2	admin	admin@university.edu	$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2	2026-01-11 12:00:27.896689	4	t	2026-01-11 12:00:27.896689
1	student	student@university.edu	$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2	2026-01-11 12:00:27.896689	1	t	2026-01-11 12:00:27.896689
4	fatemajunaed	fatema@utm.edu	$2a$12$zBEghGy6VZLLh5aUrS6H7OzXUHmmB2utBpWF8SrVCA7ENJjB91ac6	2026-01-11 12:18:42.5304	1	t	2026-01-11 12:18:42.5304
\.


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 238
-- Name: assessment_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emoticare_user
--

SELECT pg_catalog.setval('public.assessment_types_id_seq', 1, false);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 225
-- Name: badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.badges_id_seq', 4, true);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 233
-- Name: forum_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.forum_comments_id_seq', 1, true);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 231
-- Name: forum_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.forum_posts_id_seq', 3, true);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 219
-- Name: modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.modules_id_seq', 3, true);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 223
-- Name: quiz_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quiz_questions_id_seq', 2, true);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 221
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 3, true);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 236
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emoticare_user
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 229
-- Name: user_badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_badges_id_seq', 1, true);


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 227
-- Name: user_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_progress_id_seq', 3, true);


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emoticare_user
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 4862 (class 2606 OID 16843)
-- Name: assessment_types assessment_types_code_key; Type: CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.assessment_types
    ADD CONSTRAINT assessment_types_code_key UNIQUE (code);


--
-- TOC entry 4864 (class 2606 OID 16841)
-- Name: assessment_types assessment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.assessment_types
    ADD CONSTRAINT assessment_types_pkey PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 16699)
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- TOC entry 4854 (class 2606 OID 16768)
-- Name: forum_comments forum_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_comments
    ADD CONSTRAINT forum_comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4856 (class 2606 OID 16784)
-- Name: forum_likes forum_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_likes
    ADD CONSTRAINT forum_likes_pkey PRIMARY KEY (post_id, user_id);


--
-- TOC entry 4852 (class 2606 OID 16753)
-- Name: forum_posts forum_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_posts
    ADD CONSTRAINT forum_posts_pkey PRIMARY KEY (id);


--
-- TOC entry 4840 (class 2606 OID 16659)
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 16685)
-- Name: quiz_questions quiz_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_pkey PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 16669)
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2606 OID 16821)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 4860 (class 2606 OID 16819)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4850 (class 2606 OID 16731)
-- Name: user_badges user_badges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_pkey PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 16713)
-- Name: user_progress user_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_pkey PRIMARY KEY (id);


--
-- TOC entry 4834 (class 2606 OID 16648)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4836 (class 2606 OID 16644)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4838 (class 2606 OID 16646)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4868 (class 2606 OID 16700)
-- Name: badges badges_criteria_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_criteria_module_id_fkey FOREIGN KEY (criteria_module_id) REFERENCES public.modules(id) ON DELETE SET NULL;


--
-- TOC entry 4874 (class 2606 OID 16769)
-- Name: forum_comments forum_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_comments
    ADD CONSTRAINT forum_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.forum_posts(id) ON DELETE CASCADE;


--
-- TOC entry 4875 (class 2606 OID 16774)
-- Name: forum_comments forum_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_comments
    ADD CONSTRAINT forum_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4876 (class 2606 OID 16785)
-- Name: forum_likes forum_likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_likes
    ADD CONSTRAINT forum_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.forum_posts(id) ON DELETE CASCADE;


--
-- TOC entry 4877 (class 2606 OID 16790)
-- Name: forum_likes forum_likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_likes
    ADD CONSTRAINT forum_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4873 (class 2606 OID 16754)
-- Name: forum_posts forum_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_posts
    ADD CONSTRAINT forum_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4867 (class 2606 OID 16686)
-- Name: quiz_questions quiz_questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- TOC entry 4866 (class 2606 OID 16670)
-- Name: quizzes quizzes_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- TOC entry 4871 (class 2606 OID 16737)
-- Name: user_badges user_badges_badge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_badge_id_fkey FOREIGN KEY (badge_id) REFERENCES public.badges(id) ON DELETE CASCADE;


--
-- TOC entry 4872 (class 2606 OID 16732)
-- Name: user_badges user_badges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4869 (class 2606 OID 16719)
-- Name: user_progress user_progress_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- TOC entry 4870 (class 2606 OID 16714)
-- Name: user_progress user_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 16824)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emoticare_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE SET NULL;


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO emoticare_user;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE badges; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.badges TO emoticare_user;


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE badges_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.badges_id_seq TO emoticare_user;


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE forum_comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.forum_comments TO emoticare_user;


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 233
-- Name: SEQUENCE forum_comments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.forum_comments_id_seq TO emoticare_user;


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE forum_likes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.forum_likes TO emoticare_user;


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE forum_posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.forum_posts TO emoticare_user;


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE forum_posts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.forum_posts_id_seq TO emoticare_user;


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE modules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.modules TO emoticare_user;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE modules_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.modules_id_seq TO emoticare_user;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE quiz_questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.quiz_questions TO emoticare_user;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE quiz_questions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.quiz_questions_id_seq TO emoticare_user;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE quizzes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.quizzes TO emoticare_user;


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE quizzes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.quizzes_id_seq TO emoticare_user;


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE user_badges; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_badges TO emoticare_user;


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE user_badges_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.user_badges_id_seq TO emoticare_user;


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE user_progress; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_progress TO emoticare_user;


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE user_progress_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.user_progress_id_seq TO emoticare_user;


--
-- TOC entry 2099 (class 826 OID 16846)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO emoticare_user;


--
-- TOC entry 2098 (class 826 OID 16845)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO emoticare_user;


-- Completed on 2026-01-11 14:17:58

--
-- PostgreSQL database dump complete
--

\unrestrict h6a0bqbimnAVYUIk0j6uBpBz7nWMBjGOkUFIiM6UYsdxuUpeIIgAn7PPXIUnUMa

