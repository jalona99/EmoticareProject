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
CREATE TABLE public.assessment_types (
ALTER TABLE public.assessment_types OWNER TO emoticare_user;
CREATE SEQUENCE public.assessment_types_id_seq
CREATE TABLE public.badges (
ALTER TABLE public.badges OWNER TO postgres;
CREATE SEQUENCE public.badges_id_seq
CREATE TABLE public.forum_comments (
ALTER TABLE public.forum_comments OWNER TO postgres;
CREATE SEQUENCE public.forum_comments_id_seq
CREATE TABLE public.forum_likes (
ALTER TABLE public.forum_likes OWNER TO postgres;
CREATE TABLE public.forum_posts (
ALTER TABLE public.forum_posts OWNER TO postgres;
CREATE SEQUENCE public.forum_posts_id_seq
CREATE TABLE public.modules (
ALTER TABLE public.modules OWNER TO postgres;
CREATE SEQUENCE public.modules_id_seq
CREATE TABLE public.quiz_questions (
ALTER TABLE public.quiz_questions OWNER TO postgres;
CREATE SEQUENCE public.quiz_questions_id_seq
CREATE TABLE public.quizzes (
ALTER TABLE public.quizzes OWNER TO postgres;
CREATE SEQUENCE public.quizzes_id_seq
CREATE TABLE public.roles (
ALTER TABLE public.roles OWNER TO emoticare_user;
CREATE SEQUENCE public.roles_id_seq
CREATE TABLE public.user_badges (
ALTER TABLE public.user_badges OWNER TO postgres;
CREATE SEQUENCE public.user_badges_id_seq
CREATE TABLE public.user_progress (
ALTER TABLE public.user_progress OWNER TO postgres;
CREATE SEQUENCE public.user_progress_id_seq
CREATE TABLE public.users (
ALTER TABLE public.users OWNER TO emoticare_user;
CREATE SEQUENCE public.users_id_seq
ALTER TABLE ONLY public.assessment_types ALTER COLUMN id SET DEFAULT nextval('public.assessment_types_id_seq'::regclass);
ALTER TABLE ONLY public.badges ALTER COLUMN id SET DEFAULT nextval('public.badges_id_seq'::regclass);
ALTER TABLE ONLY public.forum_comments ALTER COLUMN id SET DEFAULT nextval('public.forum_comments_id_seq'::regclass);
ALTER TABLE ONLY public.forum_posts ALTER COLUMN id SET DEFAULT nextval('public.forum_posts_id_seq'::regclass);
ALTER TABLE ONLY public.modules ALTER COLUMN id SET DEFAULT nextval('public.modules_id_seq'::regclass);
ALTER TABLE ONLY public.quiz_questions ALTER COLUMN id SET DEFAULT nextval('public.quiz_questions_id_seq'::regclass);
ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);
ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
ALTER TABLE ONLY public.user_badges ALTER COLUMN id SET DEFAULT nextval('public.user_badges_id_seq'::regclass);
ALTER TABLE ONLY public.user_progress ALTER COLUMN id SET DEFAULT nextval('public.user_progress_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
COPY public.assessment_types (id, name, description, code, total_questions, min_score, max_score, created_at) FROM stdin;
COPY public.badges (id, name, description, icon_url, criteria_module_id) FROM stdin;
COPY public.forum_comments (id, post_id, user_id, content, created_at) FROM stdin;
COPY public.forum_likes (post_id, user_id, created_at) FROM stdin;
COPY public.forum_posts (id, user_id, title, content, is_flagged, created_at, updated_at, is_deleted, report_reason, reported_by, is_reported) FROM stdin;
COPY public.modules (id, title, description, content_url, created_at, updated_at) FROM stdin;
COPY public.quiz_questions (id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option, created_at) FROM stdin;
COPY public.quizzes (id, module_id, title, passing_score, created_at, updated_at) FROM stdin;
COPY public.roles (id, name, description) FROM stdin;
COPY public.user_badges (id, user_id, badge_id, earned_at) FROM stdin;
COPY public.user_progress (id, user_id, module_id, status, quiz_score, completed_at, created_at) FROM stdin;
COPY public.users (id, username, email, password, created_at, role_id, is_active, updated_at) FROM stdin;
SELECT pg_catalog.setval('public.assessment_types_id_seq', 1, false);
SELECT pg_catalog.setval('public.badges_id_seq', 4, true);
SELECT pg_catalog.setval('public.forum_comments_id_seq', 1, true);
SELECT pg_catalog.setval('public.forum_posts_id_seq', 3, true);
SELECT pg_catalog.setval('public.modules_id_seq', 3, true);
SELECT pg_catalog.setval('public.quiz_questions_id_seq', 2, true);
SELECT pg_catalog.setval('public.quizzes_id_seq', 3, true);
SELECT pg_catalog.setval('public.roles_id_seq', 1, false);
SELECT pg_catalog.setval('public.user_badges_id_seq', 1, true);
SELECT pg_catalog.setval('public.user_progress_id_seq', 3, true);
SELECT pg_catalog.setval('public.users_id_seq', 4, true);
ALTER TABLE ONLY public.assessment_types
ALTER TABLE ONLY public.assessment_types
ALTER TABLE ONLY public.badges
ALTER TABLE ONLY public.forum_comments
ALTER TABLE ONLY public.forum_likes
ALTER TABLE ONLY public.forum_posts
ALTER TABLE ONLY public.modules
ALTER TABLE ONLY public.quiz_questions
ALTER TABLE ONLY public.quizzes
ALTER TABLE ONLY public.roles
ALTER TABLE ONLY public.roles
ALTER TABLE ONLY public.user_badges
ALTER TABLE ONLY public.user_progress
ALTER TABLE ONLY public.users
ALTER TABLE ONLY public.users
ALTER TABLE ONLY public.users
ALTER TABLE ONLY public.badges
ALTER TABLE ONLY public.forum_comments
ALTER TABLE ONLY public.forum_comments
ALTER TABLE ONLY public.forum_likes
ALTER TABLE ONLY public.forum_likes
ALTER TABLE ONLY public.forum_posts
ALTER TABLE ONLY public.quiz_questions
ALTER TABLE ONLY public.quizzes
ALTER TABLE ONLY public.user_badges
ALTER TABLE ONLY public.user_badges
ALTER TABLE ONLY public.user_progress
ALTER TABLE ONLY public.user_progress
ALTER TABLE ONLY public.users
