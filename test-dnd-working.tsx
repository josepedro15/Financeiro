import React, { useState } from 'react';
import {
  DndContext,
  DragEndEvent,
  DragOverlay,
  DragStartEvent,
  PointerSensor,
  useSensor,
  useSensors,
  closestCorners,
} from '@dnd-kit/core';
import {
  SortableContext,
  verticalListSortingStrategy,
} from '@dnd-kit/sortable';
import {
  useSortable,
} from '@dnd-kit/sortable';
import {
  useDroppable,
} from '@dnd-kit/core';
import { CSS } from '@dnd-kit/utilities';

interface Item {
  id: string;
  name: string;
}

interface Column {
  id: string;
  title: string;
  items: Item[];
}

export default function TestDndWorking() {
  const [columns, setColumns] = useState<Column[]>([
    {
      id: 'col1',
      title: 'Coluna 1',
      items: [
        { id: 'item1', name: 'Item 1' },
        { id: 'item2', name: 'Item 2' },
      ]
    },
    {
      id: 'col2',
      title: 'Coluna 2',
      items: [
        { id: 'item3', name: 'Item 3' },
      ]
    }
  ]);

  const [activeItem, setActiveItem] = useState<Item | null>(null);

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 5,
      },
    })
  );

  const handleDragStart = (event: DragStartEvent) => {
    const { active } = event;
    const item = columns.flatMap(col => col.items).find(item => item.id === active.id);
    setActiveItem(item || null);
    console.log('Drag start:', item?.name);
  };

  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    setActiveItem(null);

    if (!over || !active) return;

    const itemId = active.id as string;
    const newColumnId = over.id as string;

    console.log('Drag end:', itemId, '->', newColumnId);

    setColumns(prev => {
      const newColumns = [...prev];
      
      // Find item and remove from current column
      let item: Item | undefined;
      for (const col of newColumns) {
        const itemIndex = col.items.findIndex(i => i.id === itemId);
        if (itemIndex !== -1) {
          item = col.items.splice(itemIndex, 1)[0];
          break;
        }
      }

      // Add to new column
      if (item) {
        const targetColumn = newColumns.find(col => col.id === newColumnId);
        if (targetColumn) {
          targetColumn.items.push(item);
        }
      }

      return newColumns;
    });
  };

  const SortableItem = ({ item }: { item: Item }) => {
    const {
      attributes,
      listeners,
      setNodeRef,
      transform,
      transition,
      isDragging,
    } = useSortable({ id: item.id });

    const style = {
      transform: CSS.Transform.toString(transform),
      transition,
      opacity: isDragging ? 0.5 : 1,
    };

    return (
      <div
        ref={setNodeRef}
        style={style}
        {...attributes}
        {...listeners}
        className="p-4 bg-white border rounded shadow cursor-grab active:cursor-grabbing mb-2 touch-none"
        style={{ touchAction: 'none' }}
      >
        {item.name}
      </div>
    );
  };

  const DroppableColumn = ({ column }: { column: Column }) => {
    const { setNodeRef, isOver } = useDroppable({
      id: column.id,
    });

    return (
      <div className="w-64 bg-gray-100 p-4 rounded">
        <h3 className="font-bold mb-4">{column.title}</h3>
        <div
          ref={setNodeRef}
          className={`min-h-[200px] border-2 border-dashed rounded p-2 ${
            isOver ? 'border-blue-500 bg-blue-50' : 'border-gray-300'
          }`}
        >
          <SortableContext items={column.items.map(item => item.id)} strategy={verticalListSortingStrategy}>
            {column.items.map((item) => (
              <SortableItem key={item.id} item={item} />
            ))}
          </SortableContext>
          {column.items.length === 0 && (
            <div className="text-center text-gray-500 py-8">
              Arraste itens aqui
            </div>
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-8">Teste Drag and Drop Funcional</h1>
      
      <DndContext
        sensors={sensors}
        collisionDetection={closestCorners}
        onDragStart={handleDragStart}
        onDragEnd={handleDragEnd}
      >
        <div className="flex gap-6">
          {columns.map((column) => (
            <DroppableColumn key={column.id} column={column} />
          ))}
        </div>

        <DragOverlay>
          {activeItem ? (
            <div className="p-4 bg-white border rounded shadow opacity-80">
              {activeItem.name}
            </div>
          ) : null}
        </DragOverlay>
      </DndContext>
    </div>
  );
}
