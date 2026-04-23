import Foundation



// ======================================================
// MARK: - RECOMMENDATION DATABASE
// ======================================================

// NOTE: This is a local static database. In the future it can be connected to a
// remote service (e.g. Firebase / Firestore) for dynamic updates and personalization.
// A document-based NoSQL structure maps cleanly to the Recommendation model,
// enabling new entries to be added without app redeployment.
// Also, an online database allows for a lighter app and more frequent content updates,
// which is ideal for a recommendation system that may evolve over time.
// However, the local database may be kept for offline access and as a fallback in case of connectivity issues.

class RecommendationDatabase {

    func loadRecommendations() -> [Recommendation] {
        return [
            Recommendation(
                id: UUID(),
                title: "Take a 10-minute walk",
                description: "Walking improves circulation, energy, and mental clarity.",
                physicalWeight: 0.9,
                mentalWeight: 0.5,
                mindfulnessWeight: 0.3,
                estimatedBenefit: 0.85,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Deep breathing exercise",
                description: "Slow deep breathing reduces stress and improves focus.",
                physicalWeight: 0.2,
                mentalWeight: 0.9,
                mindfulnessWeight: 0.7,
                estimatedBenefit: 0.80,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Text a friend",
                description: "Social interaction improves mood and emotional resilience.",
                physicalWeight: 0.1,
                mentalWeight: 0.4,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.75,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Stretch for 5 minutes",
                description: "Stretching relieves tension and refreshes the body.",
                physicalWeight: 0.75,
                mentalWeight: 0.4,
                mindfulnessWeight: 0.35,
                estimatedBenefit: 0.70,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Write one small goal",
                description: "Setting a small goal restores motivation and clarity.",
                physicalWeight: 0.1,
                mentalWeight: 0.6,
                mindfulnessWeight: 0.85,
                estimatedBenefit: 0.78,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Drink water",
                description: "Hydration improves energy and concentration.",
                physicalWeight: 0.65,
                mentalWeight: 0.4,
                mindfulnessWeight: 0.2,
                estimatedBenefit: 0.60,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Gratitude journaling",
                description: "Writing down positive moments improves emotional resilience.",
                physicalWeight: 0.1,
                mentalWeight: 0.75,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.84,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Guided meditation",
                description: "Meditation calms the mind and improves awareness.",
                physicalWeight: 0.15,
                mentalWeight: 0.85,
                mindfulnessWeight: 1.0,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Listen to calming music",
                description: "Music can improve mood and reduce anxiety.",
                physicalWeight: 0.05,
                mentalWeight: 0.7,
                mindfulnessWeight: 0.8,
                estimatedBenefit: 0.72,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Dance for one song",
                description: "Light dancing boosts energy and emotional release.",
                physicalWeight: 0.7,
                mentalWeight: 0.65,
                mindfulnessWeight: 0.6,
                estimatedBenefit: 0.82,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Body scan mindfulness",
                description: "Scanning your body improves awareness and reduces stress.",
                physicalWeight: 0.15,
                mentalWeight: 0.8,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.86,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Write a journal reflection",
                description: "Reflective journaling helps process emotions and thoughts.",
                physicalWeight: 0.05,
                mentalWeight: 0.8,
                mindfulnessWeight: 0.9,
                estimatedBenefit: 0.83,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "5-minute tidy up",
                description: "Cleaning your space can improve focus and reduce overwhelm.",
                physicalWeight: 0.45,
                mentalWeight: 0.7,
                mindfulnessWeight: 0.3,
                estimatedBenefit: 0.70,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Mindful breathing pause",
                description: "Pausing to breathe deeply helps reset emotional balance.",
                physicalWeight: 0.1,
                mentalWeight: 0.8,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.85,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Positive affirmation",
                description: "Repeating a positive affirmation improves mindset.",
                physicalWeight: 0.05,
                mentalWeight: 0.65,
                mindfulnessWeight: 0.85,
                estimatedBenefit: 0.68,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Leg stretches",
                description: "Stretching the legs improves mobility and reduces stiffness.",
                physicalWeight: 0.75,
                mentalWeight: 0.35,
                mindfulnessWeight: 0.25,
                estimatedBenefit: 0.71,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Brain dump journaling",
                description: "Writing down racing thoughts reduces mental overload.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.9,
                estimatedBenefit: 0.81,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Take a movement break",
                description: "Brief activity breaks reduce sedentary fatigue.",
                physicalWeight: 0.8,
                mentalWeight: 0.55,
                mindfulnessWeight: 0.25,
                estimatedBenefit: 0.78,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Step outside",
                description: "Fresh air and sunlight improve mood and alertness.",
                physicalWeight: 0.5,
                mentalWeight: 0.7,
                mindfulnessWeight: 0.6,
                estimatedBenefit: 0.79,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Organize your desk",
                description: "Organizing your workspace improves concentration.",
                physicalWeight: 0.35,
                mentalWeight: 0.75,
                mindfulnessWeight: 0.3,
                estimatedBenefit: 0.69,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Read something inspiring",
                description: "Reading something uplifting can improve motivation.",
                physicalWeight: 0.05,
                mentalWeight: 0.7,
                mindfulnessWeight: 0.6,
                estimatedBenefit: 0.67,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Dance stretch",
                description: "Combining dance and stretching energizes both body and mood.",
                physicalWeight: 0.8,
                mentalWeight: 0.65,
                mindfulnessWeight: 0.55,
                estimatedBenefit: 0.84,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Cognitive Defusion Prompt",
                description: "Write a recurring negative thought and reframe it by saying: 'I notice I am having the thought that...'",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.88,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Cognitive Defusion Prompt",
                description: "Identify a thought you treat as fact and write evidence for and against it to create distance from the thought.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.93,
                estimatedBenefit: 0.89,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Cognitive Defusion Prompt",
                description: "Imagine your inner critic as a character and describe what it looks like and what it is trying to protect you from.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.84,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Acceptance Prompt",
                description: "Describe an emotion you have been avoiding, including its weight, color, texture, and where it lives in your body.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Acceptance Prompt",
                description: "Write a letter to an uncomfortable feeling, making space for it instead of asking it to leave.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.97,
                estimatedBenefit: 0.91,
                taskTime: 12
            ),

            Recommendation(
                id: UUID(),
                title: "Acceptance Prompt",
                description: "Reflect on a time resisting an emotion made things worse, and describe what happened when you fought the feeling.",
                physicalWeight: 0.05,
                mentalWeight: 0.87,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.88,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Present Moment Awareness Prompt",
                description: "Describe what you can see, hear, smell, taste, and touch right now without interpreting it.",
                physicalWeight: 0.05,
                mentalWeight: 0.82,
                mindfulnessWeight: 1.0,
                estimatedBenefit: 0.89,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Present Moment Awareness Prompt",
                description: "Observe the sensation of breathing and describe what the air feels like entering and leaving your body.",
                physicalWeight: 0.05,
                mentalWeight: 0.80,
                mindfulnessWeight: 1.0,
                estimatedBenefit: 0.88,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Present Moment Awareness Prompt",
                description: "Choose an object near you and observe it for three minutes as if you had never seen it before.",
                physicalWeight: 0.05,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.84,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Self-Reflection Prompt",
                description: "List five labels you use for yourself and rewrite them as passing thoughts rather than fixed truths.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.94,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Self-Reflection Prompt",
                description: "Think about who you were 10 years ago and write what has changed and what has remained constant.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.86,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Self-Reflection Prompt",
                description: "Describe yourself using only verbs such as noticing, choosing, or feeling instead of labels.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.87,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Values Clarification Prompt",
                description: "List your top five values and rate how much your current life reflects each one.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.93,
                taskTime: 12
            ),

            Recommendation(
                id: UUID(),
                title: "Values Clarification Prompt",
                description: "Write about a moment when you felt most alive and identify the values you were expressing.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Values Clarification Prompt",
                description: "Imagine you are 90 years old looking back on life and reflect on what you would regret not doing.",
                physicalWeight: 0.05,
                mentalWeight: 0.95,
                mindfulnessWeight: 0.96,
                estimatedBenefit: 0.94,
                taskTime: 12
            ),

            Recommendation(
                id: UUID(),
                title: "Committed Action Prompt",
                description: "Choose one value and define one small action you can take today to move toward it.",
                physicalWeight: 0.10,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.91,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Committed Action Prompt",
                description: "Write about an action aligned with your values that you are avoiding and identify the discomfort behind the avoidance.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Committed Action Prompt",
                description: "Write a commitment statement for one action this week and how you will respond when resistance appears.",
                physicalWeight: 0.05,
                mentalWeight: 0.93,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.92,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Reframe a Thought Prompt",
                description: "Write down a painful thought and add the phrase 'I notice I am having the thought that...' before it.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.89,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Thought Evidence Prompt",
                description: "Pick one thought you believe strongly and write evidence for and against it.",
                physicalWeight: 0.05,
                mentalWeight: 0.93,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Inner Critic Prompt",
                description: "Imagine your inner critic as a character and describe its intentions.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.86,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Thought Observation Prompt",
                description: "Write three thoughts that appeared today and respond to each with 'Thank you, mind.'",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.93,
                estimatedBenefit: 0.88,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Repeat the Thought Prompt",
                description: "Repeat a distressing thought slowly and observe whether its emotional charge changes.",
                physicalWeight: 0.05,
                mentalWeight: 0.87,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.85,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Thought Weather Prompt",
                description: "Describe your current thoughts as if they were today's weather forecast.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.84,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Acceptance Letter Prompt",
                description: "Write a letter to an uncomfortable feeling, making room for it instead of resisting it.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.97,
                estimatedBenefit: 0.91,
                taskTime: 12
            ),

            Recommendation(
                id: UUID(),
                title: "Emotion Mapping Prompt",
                description: "Describe an emotion by its texture, color, weight, and where it appears in your body.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.89,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Resistance Reflection Prompt",
                description: "Reflect on a moment when resisting an emotion made your experience worse.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.88,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Emotional Willingness Prompt",
                description: "Complete the sentence: 'I am willing to feel ___ in order to ___.'",
                physicalWeight: 0.05,
                mentalWeight: 0.91,
                mindfulnessWeight: 0.94,
                estimatedBenefit: 0.90,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Five Senses Prompt",
                description: "Describe what you see, hear, smell, taste, and touch in this moment.",
                physicalWeight: 0.05,
                mentalWeight: 0.80,
                mindfulnessWeight: 1.0,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Breath Awareness Prompt",
                description: "Observe your breathing and describe the sensation of air entering and leaving your body.",
                physicalWeight: 0.05,
                mentalWeight: 0.82,
                mindfulnessWeight: 1.0,
                estimatedBenefit: 0.89,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Object Observation Prompt",
                description: "Observe an object nearby as if seeing it for the first time and write what you notice.",
                physicalWeight: 0.05,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.84,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Attention Tracking Prompt",
                description: "Notice where your attention moves for two minutes and describe its path.",
                physicalWeight: 0.05,
                mentalWeight: 0.83,
                mindfulnessWeight: 0.96,
                estimatedBenefit: 0.86,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Present Emotion Prompt",
                description: "Identify the emotion present in your body right now and describe how it feels.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.87,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Identity Labels Prompt",
                description: "List labels you use for yourself and rewrite them as thoughts instead of truths.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.94,
                estimatedBenefit: 0.89,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Past and Present Prompt",
                description: "Reflect on what has changed in you over the years and what has remained constant.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.87,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Observer Self Prompt",
                description: "Reflect on the part of you that notices thoughts and feelings without being them.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.97,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Sky and Weather Prompt",
                description: "Imagine your thoughts as weather and your awareness as the sky holding them.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.96,
                estimatedBenefit: 0.88,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Compassion Observer Prompt",
                description: "Imagine observing your life with complete compassion and describe what you see.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.96,
                estimatedBenefit: 0.91,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Values Ranking Prompt",
                description: "List your top values and rate how well your daily actions reflect them.",
                physicalWeight: 0.05,
                mentalWeight: 0.94,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.93,
                taskTime: 12
            ),

            Recommendation(
                id: UUID(),
                title: "Meaningful Moment Prompt",
                description: "Describe a moment when you felt fully alive and identify the values behind it.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Future Reflection Prompt",
                description: "Imagine looking back on your life and identify what would matter most.",
                physicalWeight: 0.05,
                mentalWeight: 0.95,
                mindfulnessWeight: 0.96,
                estimatedBenefit: 0.94,
                taskTime: 12
            ),

            Recommendation(
                id: UUID(),
                title: "Admired Qualities Prompt",
                description: "Think of someone you admire and identify the qualities you value in them.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.87,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Mission Statement Prompt",
                description: "Write a one-sentence mission statement describing what matters most to you.",
                physicalWeight: 0.05,
                mentalWeight: 0.93,
                mindfulnessWeight: 0.94,
                estimatedBenefit: 0.92,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Small Action Prompt",
                description: "Choose one small action you can take today that aligns with one of your values.",
                physicalWeight: 0.10,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.91,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Barrier Reflection Prompt",
                description: "Identify what thoughts or feelings are preventing you from taking meaningful action.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.90,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Values Commitment Prompt",
                description: "Write one action you commit to this week that reflects your values.",
                physicalWeight: 0.05,
                mentalWeight: 0.93,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.92,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Motivation vs Commitment Prompt",
                description: "Reflect on the difference between feeling motivated and staying committed.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.86,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Personal Contract Prompt",
                description: "Write a short contract describing what you will do this week and why it matters.",
                physicalWeight: 0.05,
                mentalWeight: 0.94,
                mindfulnessWeight: 0.93,
                estimatedBenefit: 0.93,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Listen to Your Favorite Song",
                description: "Play a song you love and focus on how it shifts your mood.",
                physicalWeight: 0.05,
                mentalWeight: 0.80,
                mindfulnessWeight: 0.75,
                estimatedBenefit: 0.82,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Listen to a Happy Song",
                description: "Choose an upbeat song that makes you feel energized or joyful.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.70,
                estimatedBenefit: 0.84,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Sing Along to a Song",
                description: "Sing along to a song you enjoy to release tension and boost mood.",
                physicalWeight: 0.35,
                mentalWeight: 0.80,
                mindfulnessWeight: 0.65,
                estimatedBenefit: 0.86,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Hum a Melody",
                description: "Hum a familiar melody slowly and notice how your breathing settles.",
                physicalWeight: 0.20,
                mentalWeight: 0.70,
                mindfulnessWeight: 0.80,
                estimatedBenefit: 0.78,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Repeat a Motivating Lyric",
                description: "Recite a lyric that inspires you and reflect on what it means to you.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.85,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Create a Comfort Playlist",
                description: "Build a playlist of songs that help you feel safe, calm, or understood.",
                physicalWeight: 0.05,
                mentalWeight: 0.87,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.86,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Listen to Instrumental Music",
                description: "Play instrumental music and let your feelings flow without focusing on words.",
                physicalWeight: 0.05,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.84,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Mood Matching Music",
                description: "Choose music that matches how you feel and notice what emotions surface.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.85,
                estimatedBenefit: 0.87,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Music Memory Reflection",
                description: "Listen to a meaningful song and reflect on the memory or person it reminds you of.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.88,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Discover a New Song",
                description: "Listen to a new song outside your usual style and notice how it affects your mood.",
                physicalWeight: 0.05,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.75,
                estimatedBenefit: 0.80,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Slow Breathing With Music",
                description: "Play calm music and match your breathing to the rhythm.",
                physicalWeight: 0.10,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Write About a Song",
                description: "Choose a meaningful song and write why its message connects with you.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.88,
                estimatedBenefit: 0.89,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Energy Boost Song",
                description: "Play an energizing song and let yourself feel the momentum build.",
                physicalWeight: 0.15,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.70,
                estimatedBenefit: 0.84,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Sing Without Judgment",
                description: "Sing your favorite song freely without worrying about sounding good.",
                physicalWeight: 0.35,
                mentalWeight: 0.82,
                mindfulnessWeight: 0.78,
                estimatedBenefit: 0.87,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Emotion Through Music",
                description: "Choose music that expresses what you feel when words are hard to find.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.88,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Listen With Closed Eyes",
                description: "Close your eyes during a song and notice what emotions, sensations, or images arise.",
                physicalWeight: 0.05,
                mentalWeight: 0.82,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.89,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Share a Song",
                description: "Send someone a song that reflects your mood or reminds you of them.",
                physicalWeight: 0.05,
                mentalWeight: 0.75,
                mindfulnessWeight: 0.88,
                estimatedBenefit: 0.84,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Reflect on a Favorite Artist",
                description: "Think about why a favorite artist resonates with your identity or values.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.86,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "One Song Meditation",
                description: "Use one full song as a meditation, staying present from beginning to end.",
                physicalWeight: 0.05,
                mentalWeight: 0.84,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.90,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Lyric Journaling",
                description: "Write one lyric that speaks to you and journal about why it matters.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.91,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Relax With Classical Music",
                description: "Listen to a calming classical piece and notice your body relaxing.",
                physicalWeight: 0.05,
                mentalWeight: 0.80,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.88,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Reflect After a Song",
                description: "After listening to a song, pause and name the emotion it left you with.",
                physicalWeight: 0.05,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.87,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Mindful Song Listening",
                description: "Play a song and focus fully on the rhythm, instruments, and sound details.",
                physicalWeight: 0.05,
                mentalWeight: 0.65,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.88,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Breathing With Music",
                description: "Match your breathing pace to the rhythm of a calming song.",
                physicalWeight: 0.10,
                mentalWeight: 0.70,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Beat Awareness",
                description: "Listen to the beat of a song and tap gently in rhythm.",
                physicalWeight: 0.20,
                mentalWeight: 0.60,
                mindfulnessWeight: 0.88,
                estimatedBenefit: 0.82,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Eyes Closed Listening",
                description: "Close your eyes while listening to a song and notice sensations or emotions that appear.",
                physicalWeight: 0.05,
                mentalWeight: 0.72,
                mindfulnessWeight: 0.94,
                estimatedBenefit: 0.87,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Guided Music Relaxation",
                description: "Play calming music while relaxing your body from head to toe.",
                physicalWeight: 0.10,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.96,
                estimatedBenefit: 0.91,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Favorite Song Reflection",
                description: "Listen to your favorite song and reflect on why it matters to you.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.75,
                estimatedBenefit: 0.87,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Lyric Reflection",
                description: "Read the lyrics of a song and identify lines that reflect your feelings.",
                physicalWeight: 0.05,
                mentalWeight: 0.95,
                mindfulnessWeight: 0.75,
                estimatedBenefit: 0.91,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Song Meaning Journal",
                description: "Write about what a meaningful song says about your current emotional state.",
                physicalWeight: 0.05,
                mentalWeight: 0.94,
                mindfulnessWeight: 0.78,
                estimatedBenefit: 0.90,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Emotional Playlist",
                description: "Create a playlist for a mood you want to understand or regulate.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.70,
                estimatedBenefit: 0.88,
                taskTime: 10
            ),

            Recommendation(
                id: UUID(),
                title: "Motivational Lyric Prompt",
                description: "Choose a lyric that motivates you and write what it means for your life right now.",
                physicalWeight: 0.05,
                mentalWeight: 0.93,
                mindfulnessWeight: 0.72,
                estimatedBenefit: 0.89,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Sing Your Favorite Song",
                description: "Sing along to a favorite song and notice the emotional release it creates.",
                physicalWeight: 0.35,
                mentalWeight: 0.82,
                mindfulnessWeight: 0.75,
                estimatedBenefit: 0.88,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Hum a Calming Tune",
                description: "Hum a slow melody to relax your breathing and body.",
                physicalWeight: 0.25,
                mentalWeight: 0.75,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.82,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Rhythm Drumming",
                description: "Tap or drum a steady rhythm to channel energy and improve focus.",
                physicalWeight: 0.45,
                mentalWeight: 0.82,
                mindfulnessWeight: 0.78,
                estimatedBenefit: 0.86,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Music and Movement",
                description: "Move gently with the rhythm of a song to release tension.",
                physicalWeight: 0.60,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.80,
                estimatedBenefit: 0.87,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Dance to a Song",
                description: "Dance freely to one song to boost energy and emotional expression.",
                physicalWeight: 0.75,
                mentalWeight: 0.82,
                mindfulnessWeight: 0.70,
                estimatedBenefit: 0.89,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Music Mood Mapping",
                description: "Choose songs that represent your current mood and your desired mood.",
                physicalWeight: 0.05,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.78,
                estimatedBenefit: 0.90,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Write a Simple Lyric",
                description: "Write a short lyric about how you feel right now.",
                physicalWeight: 0.05,
                mentalWeight: 0.94,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.91,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Compose a Mood Playlist",
                description: "Build a short playlist to guide your mood from stress to calm.",
                physicalWeight: 0.05,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.76,
                estimatedBenefit: 0.89,
                taskTime: 8
            ),

            Recommendation(
                id: UUID(),
                title: "Music Memory Reflection",
                description: "Listen to a meaningful song and reflect on the memory it evokes.",
                physicalWeight: 0.05,
                mentalWeight: 0.91,
                mindfulnessWeight: 0.74,
                estimatedBenefit: 0.88,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Observe Emotional Shift",
                description: "Notice how your emotions change from before to after listening to one song.",
                physicalWeight: 0.05,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.85,
                estimatedBenefit: 0.89,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Dance to Your Favorite Song",
                description: "Play your favorite song and dance freely to lift your mood and release energy.",
                physicalWeight: 0.80,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.70,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Mindful Movement Dance",
                description: "Move slowly to music while focusing on how your body feels with each movement.",
                physicalWeight: 0.70,
                mentalWeight: 0.70,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.91,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Dance for Emotional Release",
                description: "Move however feels natural and let your body express the emotions you are holding.",
                physicalWeight: 0.75,
                mentalWeight: 0.90,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.92,
                taskTime: 7
            ),

            Recommendation(
                id: UUID(),
                title: "Happy Memory Dance",
                description: "Play a song tied to a happy memory and let your body move with that feeling.",
                physicalWeight: 0.72,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.78,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Dance While Doing Chores",
                description: "Add small dance movements while doing chores to bring energy into routine tasks.",
                physicalWeight: 0.65,
                mentalWeight: 0.75,
                mindfulnessWeight: 0.60,
                estimatedBenefit: 0.82,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Freestyle Dance Break",
                description: "Take a short break to move freely and reconnect with your body.",
                physicalWeight: 0.78,
                mentalWeight: 0.80,
                mindfulnessWeight: 0.75,
                estimatedBenefit: 0.87,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Rhythmic Step Dance",
                description: "Step in rhythm to music to build focus, coordination, and momentum.",
                physicalWeight: 0.75,
                mentalWeight: 0.72,
                mindfulnessWeight: 0.80,
                estimatedBenefit: 0.85,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Slow Flow Dance",
                description: "Move gently and continuously with slow music to relax tension in the body.",
                physicalWeight: 0.65,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.92,
                estimatedBenefit: 0.89,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Confidence Dance",
                description: "Dance with bold, open movements to build confidence and shift your mindset.",
                physicalWeight: 0.80,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.72,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Energy Boost Dance",
                description: "Use upbeat music and energetic movement to increase motivation and vitality.",
                physicalWeight: 0.85,
                mentalWeight: 0.84,
                mindfulnessWeight: 0.68,
                estimatedBenefit: 0.89,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Stretch and Dance",
                description: "Combine light stretching with music-based movement to release stiffness.",
                physicalWeight: 0.78,
                mentalWeight: 0.75,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.88,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Mirror Dance Practice",
                description: "Dance in front of a mirror and focus on enjoying your movement without judgment.",
                physicalWeight: 0.75,
                mentalWeight: 0.86,
                mindfulnessWeight: 0.80,
                estimatedBenefit: 0.89,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Grounding Dance",
                description: "Focus on the feeling of your feet connecting with the floor as you move.",
                physicalWeight: 0.70,
                mentalWeight: 0.72,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.90,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "One Song Dance Break",
                description: "Take one full song to move however you want and let yourself be present.",
                physicalWeight: 0.78,
                mentalWeight: 0.80,
                mindfulnessWeight: 0.85,
                estimatedBenefit: 0.88,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Creative Expression Dance",
                description: "Use movement to express something you are feeling without using words.",
                physicalWeight: 0.75,
                mentalWeight: 0.92,
                mindfulnessWeight: 0.82,
                estimatedBenefit: 0.91,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Dance to Release Stress",
                description: "Move to energetic music to physically release built-up stress.",
                physicalWeight: 0.82,
                mentalWeight: 0.88,
                mindfulnessWeight: 0.72,
                estimatedBenefit: 0.91,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Breathing Dance",
                description: "Coordinate gentle movement with deep breathing to calm the body and mind.",
                physicalWeight: 0.68,
                mentalWeight: 0.78,
                mindfulnessWeight: 0.95,
                estimatedBenefit: 0.91,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Joyful Movement Prompt",
                description: "Move in a way that feels joyful and playful, even if it is just small gestures.",
                physicalWeight: 0.70,
                mentalWeight: 0.85,
                mindfulnessWeight: 0.78,
                estimatedBenefit: 0.89,
                taskTime: 5
            ),

            Recommendation(
                id: UUID(),
                title: "Dance and Smile",
                description: "Dance while intentionally smiling to reinforce positive emotion.",
                physicalWeight: 0.75,
                mentalWeight: 0.84,
                mindfulnessWeight: 0.75,
                estimatedBenefit: 0.87,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Gentle Body Release Dance",
                description: "Use soft movements to loosen muscle tension and reconnect with your body.",
                physicalWeight: 0.72,
                mentalWeight: 0.80,
                mindfulnessWeight: 0.90,
                estimatedBenefit: 0.90,
                taskTime: 6
            ),

            Recommendation(
                id: UUID(),
                title: "Do 20 Jumping Jacks",
                description: "Perform jumping jacks to quickly increase blood flow and wake up the body.",
                physicalWeight: 0.92,
                mentalWeight: 0.45,
                mindfulnessWeight: 0.25,
                estimatedBenefit: 0.85,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Walk Around the Room",
                description: "Walk continuously for a few minutes to improve circulation and reduce physical stagnation.",
                physicalWeight: 0.88,
                mentalWeight: 0.40,
                mindfulnessWeight: 0.35,
                estimatedBenefit: 0.82,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Quick Dance Burst",
                description: "Move energetically to one upbeat song to activate the body and boost energy.",
                physicalWeight: 0.90,
                mentalWeight: 0.55,
                mindfulnessWeight: 0.30,
                estimatedBenefit: 0.87,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Body Shake-Out",
                description: "Shake out your arms, legs, and shoulders to release tension and stimulate movement.",
                physicalWeight: 0.86,
                mentalWeight: 0.42,
                mindfulnessWeight: 0.40,
                estimatedBenefit: 0.81,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Step in Place",
                description: "Step in place at a steady pace to activate circulation and leg muscles.",
                physicalWeight: 0.87,
                mentalWeight: 0.40,
                mindfulnessWeight: 0.30,
                estimatedBenefit: 0.82,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Arm Circles",
                description: "Rotate your arms in circles to loosen the shoulders and improve upper-body mobility.",
                physicalWeight: 0.82,
                mentalWeight: 0.30,
                mindfulnessWeight: 0.35,
                estimatedBenefit: 0.78,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Bodyweight Squats",
                description: "Perform a short set of squats to activate major muscle groups.",
                physicalWeight: 0.94,
                mentalWeight: 0.42,
                mindfulnessWeight: 0.30,
                estimatedBenefit: 0.88,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Calf Raises",
                description: "Lift onto your toes repeatedly to strengthen your legs and improve circulation.",
                physicalWeight: 0.84,
                mentalWeight: 0.32,
                mindfulnessWeight: 0.25,
                estimatedBenefit: 0.79,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Stair Climb",
                description: "Walk up and down stairs for a few minutes to raise your heart rate.",
                physicalWeight: 0.95,
                mentalWeight: 0.45,
                mindfulnessWeight: 0.25,
                estimatedBenefit: 0.90,
                taskTime: 4
            ),

            Recommendation(
                id: UUID(),
                title: "Lunges",
                description: "Perform alternating lunges to engage the legs and improve balance.",
                physicalWeight: 0.92,
                mentalWeight: 0.42,
                mindfulnessWeight: 0.35,
                estimatedBenefit: 0.87,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Fast Marching",
                description: "March quickly in place to energize the body and stimulate movement.",
                physicalWeight: 0.89,
                mentalWeight: 0.45,
                mindfulnessWeight: 0.30,
                estimatedBenefit: 0.84,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Toe Touch Reaches",
                description: "Reach toward your toes repeatedly to stretch and activate your body.",
                physicalWeight: 0.85,
                mentalWeight: 0.35,
                mindfulnessWeight: 0.40,
                estimatedBenefit: 0.80,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Chair Sit-to-Stands",
                description: "Stand up and sit down repeatedly from a chair to build lower-body strength.",
                physicalWeight: 0.90,
                mentalWeight: 0.40,
                mindfulnessWeight: 0.30,
                estimatedBenefit: 0.84,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "Side Steps",
                description: "Step side to side continuously to increase mobility and body activation.",
                physicalWeight: 0.86,
                mentalWeight: 0.35,
                mindfulnessWeight: 0.35,
                estimatedBenefit: 0.81,
                taskTime: 3
            ),

            Recommendation(
                id: UUID(),
                title: "High Knees",
                description: "Raise your knees while marching to quickly energize the body.",
                physicalWeight: 0.93,
                mentalWeight: 0.48,
                mindfulnessWeight: 0.28,
                estimatedBenefit: 0.88,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Reach Up Stretch",
                description: "Stretch upward repeatedly to wake up the body and improve posture.",
                physicalWeight: 0.82,
                mentalWeight: 0.30,
                mindfulnessWeight: 0.38,
                estimatedBenefit: 0.77,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Hip Circles",
                description: "Rotate your hips slowly to improve flexibility and reduce stiffness.",
                physicalWeight: 0.83,
                mentalWeight: 0.30,
                mindfulnessWeight: 0.38,
                estimatedBenefit: 0.78,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Mini Cardio Burst",
                description: "Do any fast movement for one minute to increase heart rate and energy.",
                physicalWeight: 0.95,
                mentalWeight: 0.50,
                mindfulnessWeight: 0.25,
                estimatedBenefit: 0.89,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Stand Up and Stretch",
                description: "Stand up and stretch your whole body to reduce stiffness from sitting.",
                physicalWeight: 0.88,
                mentalWeight: 0.18,
                mindfulnessWeight: 0.20,
                estimatedBenefit: 0.80,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Desk March",
                description: "March in place beside your desk to increase circulation.",
                physicalWeight: 0.90,
                mentalWeight: 0.20,
                mindfulnessWeight: 0.15,
                estimatedBenefit: 0.82,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Chair Squats",
                description: "Stand up and sit down repeatedly from your chair to activate your legs.",
                physicalWeight: 0.93,
                mentalWeight: 0.22,
                mindfulnessWeight: 0.15,
                estimatedBenefit: 0.86,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Wall Push-Ups",
                description: "Do push-ups against the wall to activate your upper body.",
                physicalWeight: 0.91,
                mentalWeight: 0.18,
                mindfulnessWeight: 0.15,
                estimatedBenefit: 0.84,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Shoulder Rolls",
                description: "Roll your shoulders to relieve tension from sitting.",
                physicalWeight: 0.80,
                mentalWeight: 0.15,
                mindfulnessWeight: 0.20,
                estimatedBenefit: 0.74,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Arm Circles",
                description: "Rotate your arms in circles to loosen the shoulders and arms.",
                physicalWeight: 0.82,
                mentalWeight: 0.15,
                mindfulnessWeight: 0.15,
                estimatedBenefit: 0.75,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Seated Knee Lifts",
                description: "Lift your knees one at a time while seated to activate your legs.",
                physicalWeight: 0.84,
                mentalWeight: 0.15,
                mindfulnessWeight: 0.12,
                estimatedBenefit: 0.76,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Toe Taps",
                description: "Tap your toes quickly on the floor to stimulate circulation.",
                physicalWeight: 0.78,
                mentalWeight: 0.12,
                mindfulnessWeight: 0.10,
                estimatedBenefit: 0.70,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Desk Side Steps",
                description: "Step side to side next to your desk to loosen your body.",
                physicalWeight: 0.87,
                mentalWeight: 0.18,
                mindfulnessWeight: 0.15,
                estimatedBenefit: 0.79,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Mini Lunges",
                description: "Do alternating lunges to activate your legs and hips.",
                physicalWeight: 0.92,
                mentalWeight: 0.20,
                mindfulnessWeight: 0.18,
                estimatedBenefit: 0.85,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Neck Stretches",
                description: "Gently stretch your neck side to side to relieve tension.",
                physicalWeight: 0.76,
                mentalWeight: 0.12,
                mindfulnessWeight: 0.20,
                estimatedBenefit: 0.68,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Standing Side Reaches",
                description: "Reach side to side while standing to stretch your torso.",
                physicalWeight: 0.83,
                mentalWeight: 0.15,
                mindfulnessWeight: 0.18,
                estimatedBenefit: 0.75,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Heel Walk",
                description: "Walk a few steps on your heels to activate your lower legs.",
                physicalWeight: 0.86,
                mentalWeight: 0.15,
                mindfulnessWeight: 0.12,
                estimatedBenefit: 0.77,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Standing Knee Raises",
                description: "Lift your knees alternately while standing to engage your lower body.",
                physicalWeight: 0.89,
                mentalWeight: 0.18,
                mindfulnessWeight: 0.15,
                estimatedBenefit: 0.81,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Desk Push-Offs",
                description: "Push yourself lightly away from the desk edge to activate your arms.",
                physicalWeight: 0.88,
                mentalWeight: 0.15,
                mindfulnessWeight: 0.12,
                estimatedBenefit: 0.80,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Seated Leg Extensions",
                description: "Extend each leg forward repeatedly while sitting.",
                physicalWeight: 0.84,
                mentalWeight: 0.12,
                mindfulnessWeight: 0.10,
                estimatedBenefit: 0.75,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Quick Stair Steps",
                description: "Step on and off a stair or low step for a quick movement burst.",
                physicalWeight: 0.94,
                mentalWeight: 0.22,
                mindfulnessWeight: 0.15,
                estimatedBenefit: 0.87,
                taskTime: 2
            ),

            Recommendation(
                id: UUID(),
                title: "Hip Openers",
                description: "Lift and rotate your knees outward to loosen your hips.",
                physicalWeight: 0.82,
                mentalWeight: 0.15,
                mindfulnessWeight: 0.18,
                estimatedBenefit: 0.74,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Mini Jump Burst",
                description: "Do a short burst of light jumps to raise your heart rate.",
                physicalWeight: 0.95,
                mentalWeight: 0.25,
                mindfulnessWeight: 0.12,
                estimatedBenefit: 0.88,
                taskTime: 1
            ),

            Recommendation(
                id: UUID(),
                title: "Dance Burst",
                description: "Do a quick improvised choreography to a part of a song.",
                physicalWeight: 0.95,
                mentalWeight: 0.25,
                mindfulnessWeight: 0.45,
                estimatedBenefit: 0.88,
                taskTime: 1
            )
        ]
    }
}
