with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   size: Integer := 50000;
   type my_arr is array(0..size-1) of Long_Integer;
   arr: my_arr;

   task part_sum is
      entry start(active_size: Integer; last_size: Integer);
   end part_sum;

task body part_sum is
      sum: Long_Integer := 0;
   begin
      loop
         select
            accept start(active_size: Integer; last_size: Integer) do
               for i in 0..active_size-1 loop
                  if i /= last_size - i - 1 then
                     arr(i) := arr(i) + arr(last_size - i - 1);
                     arr(last_size - i - 1) := 0;
                  end if;
               end loop;
            end start;
         or
            delay 1.0;
            exit;
         end select;
      end loop;
   end part_sum;

   active_size: Integer := size;
   last_size: Integer := size;
begin

   for i in 0..size-1 loop
      arr(i) := long_integer(i);
   end loop;

   while active_size > 1 loop
      if active_size rem 2 = 0 then
         active_size := active_size / 2;
      else
         active_size := active_size / 2 + 1;
      end if;

      part_sum.start(active_size, last_size);

      last_size := active_size;
   end loop;

   Put_Line(arr(0)'Img);
end Main;


