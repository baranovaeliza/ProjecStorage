package Edu;

import java.sql.*;
import java.util.Scanner;


//цикл бесконечный, чтобы все время было видно меню

public class Main {
    //const
    private static final String DB_USERNAME = "postgres";
    private static final String DB_PASSWORD = "12344321";
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/lab2";

    public static void main(String[] args) throws Exception {
        Scanner scanner = new Scanner(System.in);

        Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);

        while (true) {
            System.out.println();
            System.out.println("1.Показать список комнат");
            System.out.println("2.Показать список стеллажей");
            System.out.println("3.Изменить максимальную температуру в комнате");
            System.out.println("4.Изменить количество свободных мест на стеллаже");
            System.out.println("5.Добавить комнату");
            System.out.println("6.Добавить стеллаж");
            System.out.println("7.Удалить комнату");
            System.out.println("8.Удалить стеллаж");
            System.out.println("9.Удалить таблицу комнат");
            System.out.println("10.Удалить таблицу стеллажей");
            System.out.println("11.Выйти");

            int command = scanner.nextInt();
            //TODO для шкафов просмотр по ключу комнаты
            //TODO для комнат просмотр по идентификатору
            if (command == 1) {
                //объект, который умеет отправлять запросы в бд
                Statement statement = connection.createStatement();
                String SQL_SELECT_TASK = "select * from public.\"Rooms\"";
                ResultSet result = statement.executeQuery(SQL_SELECT_TASK);

                while (result.next()) {
                    System.out.println( " NAME: "
                            + result.getString("name") + " USEFUL_VOLUME IN METERS : "
                            + result.getDouble("useful_volume")/1000 + " MAX_TEMPERATURE: "
                            + result.getDouble("max_temperature"));
                }
            }
            if (command == 2) {
                String SQL_SELECT_TASK = "select * from public.\"Shelfs\" where room_id " +
                        "= (select id from public.\"Rooms\" where name = ?)";
                PreparedStatement preparedStatement = connection.prepareStatement(SQL_SELECT_TASK);
                System.out.println("Введите название комнаты: ");
                scanner.nextLine();
                String name = scanner.nextLine();
                System.out.println(name);
                preparedStatement.setString(1, name);
                ResultSet result = preparedStatement.executeQuery();

                while (result.next()) {
                    System.out.println(" POSITIONS_QUANTITY: "
                            + result.getDouble("positions_quantity") + " TOTAL_LOAD: "
                            + result.getDouble("total_load"));
                }
            }
            // TODO для шкафов изменение чего-то
            //TODO удаление для шкафов и комнат
            else if (command == 3) {
                String sql = "update public.\"Rooms\" set max_temperature = 10.0 where name = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                System.out.println("Введите название комнаты: ");
                scanner.nextLine();
                String name = scanner.nextLine();
                preparedStatement.setString(1, name);
                preparedStatement.executeUpdate();
            }//TODO получать идентификатор запросом
            else if (command == 4) {
                String sql = "update public.\"Shelfs\" set positions_quantity = positions_quantity - 10 where id = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                System.out.println("Введите идентификатор комнаты: ");
                int roomId = scanner.nextInt();
                preparedStatement.setInt(1, roomId);
                preparedStatement.executeUpdate();
            } else if (command == 5) {
                String sql = "insert into public.\"Rooms\" (id,useful_volume,max_temperature," +
                        "min_temperature,max_humidity, min_humidity,name) " +
                        "values ((select max(id) from public.\"Rooms\")+1 ,?,?,?,?,?,?)";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                System.out.println("Введите название: ");
                scanner.nextLine();
                String name = scanner.nextLine();
                String sqlCheck = "select count(*) from public.\"Rooms\" where name = ?";
                PreparedStatement preparedStatement1 = connection.prepareStatement(sqlCheck);
                preparedStatement1.setString(1,name);
                ResultSet result1 = preparedStatement1.executeQuery();
                result1.next();
                if (result1.getInt("count")!=0){
                    System.err.println("Неверные данные: комната с таким именем уже присутствует!");
                    continue;
                }
                System.out.println("Введите максимальную загрузку: ");
                double vol = scanner.nextDouble();
                System.out.println("Введите максимальную температуру: ");
                double max_t = scanner.nextDouble();
                System.out.println("Введите минимальную температуру: ");
                double min_t = scanner.nextDouble();
                if (max_t<min_t){
                    System.err.println("Неверные данные: максимальная температура меньше минимальной!");
                    continue;
                }
                System.out.println("Введите максимальную влажность: ");
                double max_h = scanner.nextDouble();
                System.out.println("Введите минимальную влажность: ");
                double min_h = scanner.nextDouble();
                if (max_h<min_h){
                    System.err.println("Неверные данные: максимальная влажность меньше минимальной!");
                    continue;
                }
                preparedStatement.setDouble(1, vol);
                preparedStatement.setDouble(2, max_t);
                preparedStatement.setDouble(3, min_t);
                preparedStatement.setDouble(4, max_h);
                preparedStatement.setDouble(5, min_h);
                preparedStatement.setString(6, name);
                preparedStatement.executeUpdate();

                Statement statement = connection.createStatement();
                String SQL_SELECT_TASK = "select * from public.\"Rooms\"";
                ResultSet result = statement.executeQuery(SQL_SELECT_TASK);

                while (result.next()) {
                    System.out.println( " NAME: "
                            + result.getString("name") + " USEFUL_VOLUME IN METERS : "
                            + result.getDouble("useful_volume")/1000 + " MAX_TEMPERATURE: "
                            + result.getDouble("max_temperature"));
                }


            } else if (command == 6) {
                String sql = "insert into public.\"Shelfs\" (id,room_id," +
                        "positions_quantity,total_load,client_id) " +
                        "values ((select max(id) from public.\"Shelfs\")+1,?,?,?,?)";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                System.out.println("Введите идентификатор комнаты: ");
                int roomId = scanner.nextInt();
                System.out.println("Количество мест: ");
                int pos = scanner.nextInt();
                System.out.println("Максимальная загрузка: ");
                double total_load = scanner.nextDouble();
                System.out.println("Идентификатор клиента: ");
                int clId = scanner.nextInt();
                preparedStatement.setInt(1, roomId);
                preparedStatement.setInt(2, pos);
                preparedStatement.setDouble(3, total_load);
                preparedStatement.setInt(4, clId);
                preparedStatement.executeUpdate();

            } else if (command == 7) {
                String sql = "delete from public.\"Rooms\" where name = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                System.out.println("Введите название: ");
                scanner.nextLine();
                String name = scanner.nextLine();
                preparedStatement.setString(1, name);
                preparedStatement.executeUpdate();
            } else if (command == 8) {
                String sql = "delete from public.\"Shelfs\" where id = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                System.out.println("Идентификатор: ");
                int id = scanner.nextInt();
                preparedStatement.setInt(1, id);
                preparedStatement.executeUpdate();
            } else if (command == 11) {
                System.exit(0);
            } else if (command == 9) {
                Statement statement = connection.createStatement();
                String sql = "delete from public.\"Rooms\"";
                statement.executeUpdate(sql);
            } else if (command == 10) {
                Statement statement = connection.createStatement();
                String sql = "delete from public.\"Shelfs\"";
                statement.executeUpdate(sql);
            } else if (command > 10 || command < 1) {
                System.err.println("Команда не распознана");
            }
        }


    }
}