# FRINKELs Enterprise AI Subsystem Specification (`AI_SYSTEM.md`)
**Architected by**: Google DeepMind AI Solutions & FRINKELs AI Engineering Group  
**Target Platform**: FRINKELs Hyperlocal Discovery Engine  
**AI Core Model Engine**: Google Gemini 1.5 Flash / Pro & Imagen 3 / Edge Models

---

## 🤖 Overview

This document specifies the complete AI architecture for FRINKELs. The platform integrates 13 dedicated AI subsystems powered by Supabase Edge Functions, Vector Embeddings (pgvector), and Google Gemini APIs.

---

## 📑 Complete AI Feature Specifications

### 1. AI Personalized Greeting Engine
- **Architecture**: Serverless Edge Function triggered during app startup. Reads user time, local weather, and past interactions to return a context-aware 1-line dynamic greeting.
- **Prompt Flow**:
  `System: "You are Kittu, FRINKELs dynamic assistant." -> Context: {user_name, profession, time_of_day, city, weather} -> Output: JSON {greeting_text, mood_emoji}`
- **Database**: Stores cached greeting in `user_ai_cache` (columns: `user_id`, `greeting`, `generated_at`, `ttl`).
- **API Endpoint**: `POST /functions/v1/ai-greeting`
- **Cost Estimation**: ~$0.40 per 10,000 MAU / month (Gemini 1.5 Flash).
- **Model Recommendation**: `gemini-1.5-flash`

---

### 2. AI Chatbot ("Kittu" AI Assistant)
- **Architecture**: Real-time conversational AI integrated directly into the chat tab using Supabase Realtime & Server-Sent Events (SSE) streaming.
- **Prompt Flow**:
  `System: "You are Kittu, a helpful hyperlocal guide and career advisor." -> Conversation History -> User Input -> Streaming Response`.
- **Database**: Table `ai_chat_sessions` (`id`, `user_id`, `messages` JSONB, `tokens_used`, `created_at`).
- **API Endpoint**: `POST /functions/v1/ai-chat-stream`
- **Cost Estimation**: ~$12.00 per 10,000 MAU / month.
- **Model Recommendation**: `gemini-1.5-flash` (Streaming).

---

### 3. AI Profile Assistant (Bio & Skills Optimizer)
- **Architecture**: On-demand utility that analyzes a user's rough experience notes and auto-generates professional bios and skill tags.
- **Prompt Flow**:
  `Input: {raw_bio, target_industry} -> Prompt: "Optimize this bio for a professional hyperlocal profile. Output 3 variations and 10 skill keywords."`
- **Database**: `profiles` table update (`bio`, `skills`).
- **API Endpoint**: `POST /functions/v1/ai-optimize-profile`
- **Cost Estimation**: ~$1.50 per 10,000 MAU / month.
- **Model Recommendation**: `gemini-1.5-pro`

---

### 4. AI Resume Builder
- **Architecture**: PDF resume parsing and structural enhancement pipeline. Converts user work history into structured JSON and standard PDF templates.
- **Prompt Flow**:
  `Input: {work_history_json} -> Prompt: "Format into ATS-friendly executive bullet points."`
- **Database**: Table `user_resumes` (`id`, `user_id`, `resume_json` JSONB, `pdf_url`).
- **API Endpoint**: `POST /functions/v1/ai-generate-resume`
- **Cost Estimation**: ~$4.50 per 10,000 MAU / month.
- **Model Recommendation**: `gemini-1.5-pro`

---

### 5. AI Job Matcher
- **Architecture**: Vector similarity search combining job posting embeddings (`768-dim`) with user candidate profile embeddings in Supabase `pgvector`.
- **Prompt Flow**:
  `Candidate Embedding <-> Job Embedding Cosine Similarity -> Rerank top 20 candidates.`
- **Database**: Tables `jobs` (`title_vector`), `profiles` (`profile_vector`), RPC `match_candidate_to_jobs()`.
- **API Endpoint**: `POST /functions/v1/ai-match-jobs`
- **Cost Estimation**: ~$2.00 per 10,000 MAU / month (text-embedding-004).
- **Model Recommendation**: `text-embedding-004` & `gemini-1.5-flash`

---

### 6. AI Feed Ranking Engine
- **Architecture**: Machine learning ranking pipeline evaluating engagement probability (click, like, comment, dwell time) per feed post.
- **Prompt Flow**:
  `Feature Vector: [user_affinity, post_recency, location_proximity, media_type] -> Scored Ranking.`
- **Database**: RPC `get_ranked_feed(user_id, limit, offset)`.
- **API Endpoint**: `POST /functions/v1/ai-rank-feed`
- **Cost Estimation**: ~$1.80 per 10,000 MAU / month.
- **Model Recommendation**: Custom LightGBM / Edge Function scoring.

---

### 7. AI Community Recommendations
- **Architecture**: Graph-based collaborative filtering predicting relevant local communities based on profession, location, and user network.
- **Prompt Flow**:
  `Input: {user_interests, user_location, followed_users} -> Output: Recommended Community IDs.`
- **Database**: RPC `get_suggested_communities(user_id)`.
- **API Endpoint**: `POST /functions/v1/ai-recommend-communities`
- **Cost Estimation**: ~$0.80 per 10,000 MAU / month.
- **Model Recommendation**: `gemini-1.5-flash`

---

### 8. AI Custom Sticker Generator
- **Architecture**: Generative AI image generation creating dynamic chat stickers from text prompts.
- **Prompt Flow**:
  `Input: "Funny software engineer drinking coffee sticker, cartoon vector style, transparent background"`
- **Database**: Table `ai_generated_stickers` (`id`, `user_id`, `prompt`, `image_url`).
- **API Endpoint**: `POST /functions/v1/ai-generate-sticker`
- **Cost Estimation**: ~$35.00 per 10,000 MAU / month (Imagen 3).
- **Model Recommendation**: `imagen-3-fast`

---

### 9. AI Caption Generator for Posts & Media
- **Architecture**: Vision AI model analyzing uploaded images/videos to suggest engaging social captions and hashtags.
- **Prompt Flow**:
  `Input: Image Binary -> Prompt: "Describe image and generate 3 engaging captions with relevant hashtags."`
- **Database**: None (ephemeral response).
- **API Endpoint**: `POST /functions/v1/ai-generate-caption`
- **Cost Estimation**: ~$3.20 per 10,000 MAU / month.
- **Model Recommendation**: `gemini-1.5-flash` (Multimodal)

---

### 10. AI Real-Time Translation
- **Architecture**: Low-latency multilingual translation pipeline for chat messages and feed posts.
- **Prompt Flow**:
  `Input: {text, target_language} -> Prompt: "Translate accurately preserving local nuance."`
- **Database**: Cache table `translations_cache` (`text_hash`, `lang`, `translated_text`).
- **API Endpoint**: `POST /functions/v1/ai-translate`
- **Cost Estimation**: ~$2.50 per 10,000 MAU / month.
- **Model Recommendation**: `gemini-1.5-flash`

---

### 11. AI Automated Content Moderation
- **Architecture**: Real-time moderation filter intercepting posts, comments, and images prior to public indexing.
- **Prompt Flow**:
  `Input: Content -> Safety Check: [NSFW, Hate Speech, Violence, Harassment] -> Pass / Flag / Block.`
- **Database**: Table `moderation_logs` (`entity_id`, `entity_type`, `flag_reason`, `confidence_score`).
- **API Endpoint**: `POST /functions/v1/ai-moderate-content`
- **Cost Estimation**: ~$1.20 per 10,000 MAU / month.
- **Model Recommendation**: `gemini-1.5-flash` (Safety API)

---

### 12. AI Spam & Bot Detection Engine
- **Architecture**: Anomaly detection monitoring rapid post creation, duplicate messages, and fake profile signups.
- **Prompt Flow**:
  `Feature Vector: [account_age, IP_changes, duplicate_text_ratio] -> Risk Score (0-100).`
- **Database**: Table `spam_analysis` (`user_id`, `risk_score`, `is_shadowbanned`).
- **API Endpoint**: `POST /functions/v1/ai-detect-spam`
- **Cost Estimation**: ~$0.90 per 10,000 MAU / month.
- **Model Recommendation**: Scikit-learn Classifier on Edge / Gemini Flash.

---

### 13. AI Hybrid & Vector Search Engine
- **Architecture**: Combined Keyword (Full-Text Search) + Vector Embedding (Semantic Search) pipeline using Reciprocal Rank Fusion (RRF).
- **Prompt Flow**:
  `Query -> Generate Query Embedding -> Hybrid Postgres RPC Search -> RRF Reranking -> Results.`
- **Database**: RPC `hybrid_search_all(query_text, query_vector)`.
- **API Endpoint**: `POST /functions/v1/ai-hybrid-search`
- **Cost Estimation**: ~$4.00 per 10,000 MAU / month.
- **Model Recommendation**: `text-embedding-004` & `gemini-1.5-flash`

---

## 💰 Total Estimated AI Operating Cost

| Component | Target Model | Monthly Cost / 10k MAU |
|---|---|---|
| AI Greeting & Kittu Chat | Gemini 1.5 Flash | $12.40 |
| Profile & Resume Assistant | Gemini 1.5 Pro | $6.00 |
| Matching & Feed Ranking | Embeddings + Edge scoring | $3.80 |
| Sticker Generation | Imagen 3 Fast | $35.00 |
| Moderation & Spam Filter | Gemini 1.5 Flash | $2.10 |
| Hybrid AI Search | Text-Embedding-004 | $4.00 |
| **TOTAL ESTIMATED COST** | - | **~$63.30 / 10k MAU** |
