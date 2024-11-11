import { useState, useEffect, useCallback } from 'react';
import { Card } from 'primereact/card';
import { Button } from 'primereact/button';
import { ProgressSpinner } from 'primereact/progressspinner';
import './StoryInteraction.css';
import UserChoice from '@/enums/UserChoice';

interface Scenario {
    id: string;
    description: string;
}

interface Outcome {
    id: string;
    result: string;
}

const StoryInteraction = () => {
    const [scenario, setScenario] = useState<Scenario | null>(null);
    const [outcome, setOutcome] = useState<Outcome | null>(null);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null); // For error state

    const fetchScenario = useCallback(async () => {
        setIsLoading(true);
        setError(null);
        try {
            const response = await fetch('http://localhost:3000/scenarios', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            if (!response.ok) {
                throw new Error('Failed to fetch scenario');
            }
            const data = await response.json();
            setScenario(data);
        } catch (error) {
            console.error('Error fetching scenario:', error);
            setError('Error fetching scenario. Please try again later.');
        } finally {
            setIsLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchScenario();
    }, [fetchScenario]);

    const handleChoice = async (choice: UserChoice) => {
        if (!scenario) return;

        setIsLoading(true);
        setError(null);
        try {
            const response = await fetch('http://localhost:3000/outcomes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ scenarioId: scenario.id, choice }),
            });
            if (!response.ok) {
                throw new Error('Failed to submit choice');
            }
            const data = await response.json();
            setOutcome(data);
            setScenario(null);
        } catch (error) {
            console.error('Error submitting choice:', error);
            setError('Error submitting choice. Please try again later.');
        } finally {
            setIsLoading(false);
        }
    };

    const resetGame = () => {
        setScenario(null);
        setOutcome(null);
        fetchScenario();
    };

    const renderFooter = () => (
        <div className="button-container">
            {outcome ? (
                <Button
                    label="Play again"
                    onClick={resetGame}
                    className="p-button-outlined choice-button"
                    disabled={isLoading}
                />
            ) : (
                <>
                    <Button
                        label="Yes"
                        onClick={() => handleChoice(UserChoice.YES)}
                        className="p-button-outlined choice-button"
                        disabled={isLoading || !scenario}
                    />
                    <Button
                        label="No"
                        onClick={() => handleChoice(UserChoice.NO)}
                        className="p-button-outlined choice-button"
                        disabled={isLoading || !scenario}
                    />
                </>
            )}
        </div>
    );

    const renderContent = () => {
        if (isLoading) {
            return (
                <div className="spinner-container">
                    <ProgressSpinner />
                </div>
            );
        }
        if (error) {
            return <div className="error-text">{error}</div>;
        }
        if (scenario) {
            return (
                <>
                    <p className="passage-text">{scenario.description}</p>
                    <p className="text3xl font-bold underline">DO YOU OPEN THE BOX?</p>
                </>
            );
        }
        if (outcome) {
            return <p className="passage-text">{outcome.result}</p>;
        }
        return <div className="error-text">Failed to load scenario or outcome</div>;
    };

    return (
        <Card footer={renderFooter()} className="story-card">
            {renderContent()}
        </Card>
    );
};

export default StoryInteraction;
