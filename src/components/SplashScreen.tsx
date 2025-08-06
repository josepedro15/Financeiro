import { useEffect } from 'react';

interface SplashScreenProps {
  onFinish: () => void;
}

export default function SplashScreen({ onFinish }: SplashScreenProps) {
  useEffect(() => {
    const timer = setTimeout(() => {
      onFinish();
    }, 6000); // 6s total

    return () => clearTimeout(timer);
  }, [onFinish]);

  return (
    <div 
      className="fixed inset-0 bg-white z-50 flex items-center justify-center"
      aria-hidden="true"
    >
      <div className="text-center leading-tight relative">
        <span 
          className="absolute inset-0 flex items-center justify-center text-4xl md:text-6xl font-semibold text-[#0D0D0D] animate-phrase-one"
          style={{ fontFamily: 'Inter, sans-serif' }}
        >
          Think different.
        </span>
        <span 
          className="absolute inset-0 flex items-center justify-center text-4xl md:text-6xl font-semibold text-[#0D0D0D] animate-phrase-two"
          style={{ fontFamily: 'Inter, sans-serif' }}
        >
          Elevate every idea.
        </span>
        {/* Span invisível para manter o espaço */}
        <span className="invisible text-4xl md:text-6xl font-semibold">
          Elevate every idea.
        </span>
      </div>
    </div>
  );
}