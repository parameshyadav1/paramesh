import React, { useState } from 'react';
import { DragDropContext, Droppable, Draggable } from 'react-beautiful-dnd';
import { ResizableBox } from 'react-resizable';
import 'react-resizable/css/styles.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css'; // Include your custom styles here

const initialCards = [
  { id: '1', content: 'Card 1', width: 250, height: 150, likes: 0, liked: false },
  { id: '2', content: 'Card 2', width: 250, height: 150, likes: 0, liked: false },
  { id: '3', content: 'Card 3', width: 250, height: 150, likes: 0, liked: false },
];

function App() {
  const [cards, setCards] = useState(initialCards);
  const [newCardContent, setNewCardContent] = useState('');

  const onDragEnd = (result) => {
    const { destination, source } = result;

    if (!destination) return;

    const newCards = Array.from(cards);
    const [movedCard] = newCards.splice(source.index, 1);
    newCards.splice(destination.index, 0, movedCard);

    setCards(newCards);
  };

  const addCard = () => {
    if (newCardContent.trim() === '') return;

    const newCard = {
      id: `${cards.length + 1}`,
      content: newCardContent,
      width: 250,
      height: 150,
      likes: 0,
      liked: false,
    };
    setCards([...cards, newCard]);
    setNewCardContent('');
  };

  const toggleLike = (id) => {
    const updatedCards = cards.map(card => {
      if (card.id === id) {
        const newLikes = card.liked ? card.likes - 1 : card.likes + 1;
        return { ...card, liked: !card.liked, likes: newLikes };
      }
      return card;
    });
    setCards(updatedCards);
  };

  return (
    <div className="container mt-5">
      <div className="d-flex mb-4">
        <input
          type="text"
          className="form-control me-2"
          placeholder="Enter card content"
          value={newCardContent}
          onChange={(e) => setNewCardContent(e.target.value)}
        />
        <button className="btn btn-primary" onClick={addCard}>Add Card</button>
      </div>

      <DragDropContext onDragEnd={onDragEnd}>
        <Droppable droppableId="droppable" direction="horizontal">
          {(provided) => (
            <div
              ref={provided.innerRef}
              {...provided.droppableProps}
              className="d-flex flex-row flex-wrap gap-3"
            >
              {cards.map((card, index) => (
                <Draggable key={card.id} draggableId={card.id} index={index}>
                  {(provided) => (
                    <div
                      ref={provided.innerRef}
                      {...provided.draggableProps}
                      {...provided.dragHandleProps}
                      className="card bg-light border border-secondary rounded shadow-sm"
                      style={{ 
                        ...provided.draggableProps.style, 
                        ...provided.dragHandleProps.style,
                        margin: '0 16px 16px 0',
                        width: card.width,
                        height: card.height
                      }}
                    >
                      <ResizableBox
                        width={card.width}
                        height={card.height}
                        minConstraints={[150, 100]}
                        maxConstraints={[400, 300]}
                        className="resizable-box"
                      >
                        <div className="card-content p-3">
                          <div className="card-title">{card.content}</div>
                          <div className="d-flex align-items-center mt-2">
                            <button
                              className={`btn btn-${card.liked ? 'danger' : 'outline-secondary'} me-2`}
                              onClick={() => toggleLike(card.id)}
                            >
                              {card.liked ? 'Unlike' : 'Like'}
                            </button>
                            <span>{card.likes} {card.likes === 1 ? 'Like' : 'Likes'}</span>
                          </div>
                        </div>
                      </ResizableBox>
                    </div>
                  )}
                </Draggable>
              ))}
              {provided.placeholder}
            </div>
          )}
        </Droppable>
      </DragDropContext>
    </div>
  );
}

export default App;
